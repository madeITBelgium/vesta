%global _hardened_build 1

%define WITH_CC_OPT $(echo %{optflags} $(pcre2-config --cflags)) -fPIC
%define WITH_LD_OPT -Wl,-z,relro -Wl,-z,now -pie

%define BASE_CONFIGURE_ARGS $(echo "--prefix=/usr/local/vesta/nginx --conf-path=/usr/local/vesta/nginx/conf/nginx.conf --error-log-path=%{_localstatedir}/log/vesta/nginx-error.log --http-log-path=%{_localstatedir}/log/vesta/access.log --pid-path=%{_rundir}/vesta-nginx.pid --lock-path=%{_rundir}/vesta-nginx.lock --http-client-body-temp-path=%{_localstatedir}/cache/vesta-nginx/client_temp --http-proxy-temp-path=%{_localstatedir}/cache/vesta-nginx/proxy_temp --http-fastcgi-temp-path=%{_localstatedir}/cache/vesta-nginx/fastcgi_temp --http-scgi-temp-path=%{_localstatedir}/cache/vesta-nginx/scgi_temp --user=admin --group=admin --with-compat --with-file-aio --with-threads --with-http_addition_module --with-http_auth_request_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_realip_module --with-http_secure_link_module --with-http_slice_module --with-http_ssl_module --with-http_stub_status_module --with-http_sub_module --with-http_v2_module --with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module")


Name:           vesta-nginx
Version:        1.25.1
Release:        1%{dist}
Summary:        Vesta internal nginx web server
Group:          System Environment/Base
URL:            https://www.tpweb.org
Source0:        https://nginx.org/download/nginx-%{version}.tar.gz
Source1:        vesta-nginx.service
Source2:        nginx.conf
License:        BSD
Vendor:         madeit.be
Requires:       redhat-release >= 8
Requires:       vesta-php
Provides:       vesta-nginx = %{version}
BuildRequires:  gcc, zlib-devel, pcre2-devel, openssl-devel, systemd

%description
This package contains internal nginx webserver for Vesta Control Panel web interface.

%prep
%autosetup -p1 -n nginx-%{version}

%build
./configure %{BASE_CONFIGURE_ARGS} \
    --with-cc-opt="%{WITH_CC_OPT}" \
    --with-ld-opt="%{WITH_LD_OPT}"
%make_build

%install
%{__rm} -rf $RPM_BUILD_ROOT
%{__make} DESTDIR=$RPM_BUILD_ROOT INSTALLDIRS=vendor install
mkdir -p %{buildroot}%{_unitdir}
%{__install} -m644 %{SOURCE1} %{buildroot}%{_unitdir}/vesta-nginx.service
rm -f %{buildroot}/usr/local/vesta/nginx/conf/nginx.conf
cp %{SOURCE2} %{buildroot}/usr/local/vesta/nginx/conf/nginx.conf
mv %{buildroot}/usr/local/vesta/nginx/sbin/nginx %{buildroot}/usr/local/vesta/nginx/sbin/vesta-nginx

%clean
%{__rm} -rf $RPM_BUILD_ROOT

%pre

%post
%systemd_post vesta-nginx.service

%preun
%systemd_preun vesta-nginx.service

%postun
%systemd_postun_with_restart vesta-nginx.service

%files
%defattr(-,root,root)
%attr(755,root,root) /usr/local/vesta/nginx
%config(noreplace) /usr/local/vesta/nginx/conf/nginx.conf
%{_unitdir}/vesta-nginx.service


%changelog
* Mon Mar 25 2024 Tjebbe Lievens <tjebbe@madeit.be> - 0.0.37
- VestaCP RHEL 9 support