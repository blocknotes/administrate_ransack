# Development

## Releases

```sh
# Update lib/administrate_ransack/version.rb with the new version
# Update the gemfiles:
bin/appraisal
```

## Testing

```sh
# Running specs per Rails/Administrate versions:
bin/appraisal rails60-administrate016 rspec
# Using latest Administrate version:
bin/appraisal rails70-administrate rspec
# See gemfiles for more configurations
```
