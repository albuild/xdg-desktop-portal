Summary: xdg-desktop-portal for Amazon Linux 2
Name: albuild-xdg-desktop-portal
Version: {{VERSION}}
Release: 1%{?dist}
Group: System Environment/Libraries
License: BSD-3-Clause
Source0: {{SOURCE0}}
Source1: {{SOURCE1}}
# Source2: {{SOURCE2}}
# Source3: {{SOURCE3}}
URL: https://github.com/albuild/xdg-desktop-portal
BuildArch: x86_64
# AutoReqProv: no

%define versiondir /opt/albuild-xdg-desktop-portal/%{version}

%description
Yet another unofficial xdg-desktop-portal package for Amazon Linux 2.

%install
mkdir -p `dirname %{buildroot}%{versiondir}`
cp -r %{versiondir} `dirname %{buildroot}%{versiondir}`
# cp -r /dest/* %{buildroot}/
find /dest -maxdepth 1 -print0 | while IFS= read -r -d $'\0' f; do
  if [ ! $f = "/dest" ]; then
    cp -r $f %{buildroot}/
  fi
done

%clean
rm -rf %{buildroot}

%files
