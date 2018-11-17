# container_baseimage Cookbook

This cookbook includes recipes to prepare a Ubuntu/Debian baseimage for Docker/Rkt/LXC usage.

## Requirements

### Platforms

- Ubuntu 18.04+

May work with or without modification on other Debian derivatives.

### Chef

- Chef 13.3+

### Cookbooks

- None

## Recipes

### default

Configures a container friendly baseimage that covers many corner cases including PID 1 zombie reaping, runit, cron and syslog daemons as well as log rotation.

## Maintainers

This cookbook is maintained by Morton Jonuschat <m.jonuschat@mojocode.de>

## License

**Copyright:** 2018, Morton Jonuschat

```
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
