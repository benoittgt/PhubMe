# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [0.5.5] - 2017-03-31
- Manage case when the slack bot is deactivated. Notify it on logs.
- Update dependencies

## [0.5.4] - 2017-02-19
- Fix crash when github test endpoint at webhook creation (#14)
- Calls need to have github key in the header (#14)

## [0.5.3] - 2017-02-04
- Be able to use Elixir 1.3 and 1.4

## [0.5.2] - 2017-02-04
- Update dependencies and jump to elixir 1.4.1

## [0.4.1] - 2016-11-02
- User elixir logger rather than IO.puts (https://github.com/benoittgt/PhubMe/pull/11)
- Use struct for params flow (#13)
- Add documentation for hex doc

## [0.4.0] - 2016-10-06
### Added
- Support no-issue comment payload from github
- Support comment without matching nicknames

### Changed
- The way I version my app. I failed.

## [0.0.3] - 2016-08-01
### Added
- Add documentation - 8f5c2cf
- Add heroku buildpack config

### Changed
- Map correctly `plug` port with Heroku `$PORT`
- Fail gracefully when wrong slack auth
- Fix test for `/phub_me` POST

## [0.0.2]
### Added
- Add SystemEnv request
- Added slack support

### Changed
- Change endpoint for POST request

## [0.0.1]
### Added
Initial commit
