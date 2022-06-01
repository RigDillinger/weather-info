# README

### Setup
```bash
dip provision
```
### Launch
```bash
dip compose up
```
### Navigate to http://localhost:3000
Default superadmin creds: superadmin@test.com / 12345678

### Prepare test DB
```bash
dip rails db:migrate RAILS_ENV=test
```
### Run tests
```bash
dip rspec
```
