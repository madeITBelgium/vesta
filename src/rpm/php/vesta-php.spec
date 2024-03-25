%global _hardened_build 1
%global _prefix /usr/local/vesta/php

Name:           vesta-php
Version:        8.2.8
Release:        1
Summary:        Vesta internal PHP
Group:          System Environment/Base
URL:            https://www.vestacp.com
Source0:        https://www.php.net/distributions/php-%{version}.tar.gz
Source1:        vesta-php.service
Source2:        php-fpm.conf
Source3:        php.ini
License:        PHP and Zend and BSD and MIT and ASL 1.0 and NCSA
Vendor:         vestacp.com
Requires:       redhat-release >= 8
Provides:       vesta-php = %{version}
BuildRequires:  autoconf, automake, bison, bzip2-devel, gcc, gcc-c++, gnupg2, libtool, make, openssl-devel, re2c
BuildRequires:  gmp-devel, oniguruma-devel, libzip-devel
BuildRequires:  pkgconfig(libcurl) >= 7.61.0
BuildRequires:  pkgconfig(libxml-2.0) >= 2.9.7
BuildRequires:  pkgconfig(sqlite3) >= 3.26.0
BuildRequires:  systemd

%description
This package contains internal PHP for Vesta Control Panel web interface.

%prep
%autosetup -p1 -n php-%{version}

# https://bugs.php.net/63362 - Not needed but installed headers.
# Drop some Windows specific headers to avoid installation,
# before build to ensure they are really not needed.
rm -f TSRM/tsrm_win32.h \
      TSRM/tsrm_config.w32.h \
      Zend/zend_config.w32.h \
      ext/mysqlnd/config-win.h \
      ext/standard/winver.h \
      main/win32_internal_function_disabled.h \
      main/win95nt.h

%build
%if 0%{?rhel} > 8
# This package fails to build with LTO due to undefined symbols.  LTO
# was disabled in OpenSuSE as well, but with no real explanation why
# beyond the undefined symbols.  It really should be investigated further.
# Disable LTO
%define _lto_cflags %{nil}
%endif
%configure --sysconfdir=%{_prefix}/etc \
	--with-libdir=lib/$(arch)-linux-gnu \
	--enable-fpm --with-fpm-user=admin --with-fpm-group=admin \
	--with-openssl \
	--with-mysqli \
	--with-gettext \
	--with-curl \
	--with-zip \
	--with-gmp \
	--enable-mbstring
make %{?_smp_mflags}

%install
%{__rm} -rf $RPM_BUILD_ROOT
make install INSTALL_ROOT=$RPM_BUILD_ROOT/usr/local/vesta/php

# Create necessary directory structure
mkdir -p $RPM_BUILD_ROOT%{_prefix}/bin

# Copy PHP executable to the specified location
cp $RPM_BUILD_ROOT/usr/local/vesta/php/bin/php $RPM_BUILD_ROOT%{_prefix}/bin/

# Install configuration files
install -D -m 644 %{SOURCE1} %{buildroot}%{_unitdir}/vesta-php.service
install -D -m 644 %{SOURCE2} %{buildroot}%{_prefix}/etc/php-fpm.conf
install -D -m 644 %{SOURCE3} %{buildroot}%{_prefix}/lib/php.ini

%files
%defattr(-,root,root)
%dir %{_prefix}
%{_prefix}/bin/php
%{_prefix}/etc/php-fpm.conf
%{_prefix}/lib/php.ini
%{_unitdir}/vesta-php.service

%changelog
* Mon Mar 25 2024 Tjebbe Lievens <tjebbe@madeit.be> - 0.0.37
- VestaCP RHEL 9 support