# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## HEAD
- User elixir logger rather than IO.puts (https://github.com/benoittgt/PhubMe/pull/11)

## [0.4.0] - 2016-11-06
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
