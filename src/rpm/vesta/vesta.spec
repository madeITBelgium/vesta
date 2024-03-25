%define debug_package %{nil}
%global _hardened_build 1

Name:           vesta
Version:        0.0.37
Release:        1
Summary:        Vesta Control Panel
Group:          System Environment/Base
License:        GPLv3
URL:            https://www.tpweb.org
Source0:        vesta-%{version}.tar.gz
Source1:        vesta.service
Vendor:         madeit.be
Requires:       redhat-release >= 8
Requires:       bash, chkconfig, gawk, sed, acl, sysstat, (setpriv or util-linux), zstd, jq
Conflicts:      vesta
Provides:       vesta = %{version}
BuildRequires:  systemd

%description
This package contains the Vesta Control Panel.

%prep
%autosetup -p1 -n vesta

%build

%install
%{__rm} -rf $RPM_BUILD_ROOT
mkdir -p %{buildroot}%{_unitdir} %{buildroot}/usr/local/vesta
cp -R %{_builddir}/vesta/* %{buildroot}/usr/local/vesta/
%{__install} -m644 %{SOURCE1} %{buildroot}%{_unitdir}/vesta.service

%clean
%{__rm} -rf $RPM_BUILD_ROOT

%post
%systemd_post vesta.service

if [ -e "/usr/local/vesta/data/users/" ]; then
    ###############################################################
    #                Initialize functions/variables               #
    ###############################################################

    bash /usr/local/vesta/afterUpdate.sh
fi

%preun
%systemd_preun vesta.service

%postun
%systemd_postun_with_restart vesta.service

%files
%defattr(-,root,root)
%attr(755,root,root) /usr/local/vesta
%{_unitdir}/vesta.service

%changelog
* Mon Mar 25 2024 Tjebbe Lievens <tjebbe@madeit.be> - 0.0.37
- RHEL 9 support