Name:		c-b20-515-04
Version:	1.0
Release:	1%{?dist}
Summary:	Программа студента Гиниятовой Алсу группы Б20-515

Group:		Testing
License:	GPL
URL:		https://github.com/alsuginiyatova/OSS_LABS
Source0:	%{name}-%{version}.tar.gz

BuildRequires:	gcc

%global debug_package %{nil}

%description
A test package

%prep
%setup -q


%build
gcc -O2 -o c-b20-515-04 c-b20-515-04.c


%install
mkdir -p %{buildroot}%{_bindir}
cp c-b20-515-04 %{buildroot}%{_bindir}
sudo rpm -i ~/rpmbuild/RPMS/noarch/b20-515-04-1.0-1.el8.noarch.rpm --force


%files
%{_bindir}/c-b20-515-04

%changelog
* Thu Jun 01 2023 Giniyatova
- Added %{_bindir}/c-b20-515-04
