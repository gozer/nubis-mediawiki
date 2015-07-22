# Change Log

## [v0.9.0](https://github.com/nubisproject/nubis-mediawiki/tree/v0.9.0) (2015-07-22)

**Merged pull requests:**

- Updates for 0.9.0 release [\#41](https://github.com/Nubisproject/nubis-mediawiki/pull/41) ([tinnightcap](https://github.com/tinnightcap))

- Add StacksVersion argument, helps along nubisproject/nubis-stacks\#41 [\#40](https://github.com/Nubisproject/nubis-mediawiki/pull/40) ([gozer](https://github.com/gozer))

- Rename KeyName to SSHKeyName, for nubisproject/nubis-docs\#35 [\#39](https://github.com/Nubisproject/nubis-mediawiki/pull/39) ([tinnightcap](https://github.com/tinnightcap))

- use curl instead of ec2metadata [\#38](https://github.com/Nubisproject/nubis-mediawiki/pull/38) ([gozer](https://github.com/gozer))

- One additional rename from dev to prod [\#37](https://github.com/Nubisproject/nubis-mediawiki/pull/37) ([tinnightcap](https://github.com/tinnightcap))

- Change from dev to stage [\#36](https://github.com/Nubisproject/nubis-mediawiki/pull/36) ([tinnightcap](https://github.com/tinnightcap))

- Moving to standard consul script [\#35](https://github.com/Nubisproject/nubis-mediawiki/pull/35) ([tinnightcap](https://github.com/tinnightcap))

- Adjust broken link [\#34](https://github.com/Nubisproject/nubis-mediawiki/pull/34) ([tinnightcap](https://github.com/tinnightcap))

- Update README to reflect current state [\#33](https://github.com/Nubisproject/nubis-mediawiki/pull/33) ([tinnightcap](https://github.com/tinnightcap))

- Several minor fixes [\#32](https://github.com/Nubisproject/nubis-mediawiki/pull/32) ([tinnightcap](https://github.com/tinnightcap))

- get rid of mysql server [\#31](https://github.com/Nubisproject/nubis-mediawiki/pull/31) ([gozer](https://github.com/gozer))

- Bring in a StorageStack [\#30](https://github.com/Nubisproject/nubis-mediawiki/pull/30) ([gozer](https://github.com/gozer))

- Rework main.json to use nested stacks with lambda [\#29](https://github.com/Nubisproject/nubis-mediawiki/pull/29) ([tinnightcap](https://github.com/tinnightcap))

- Converting elb and ec2 stacks to parameter lookup [\#28](https://github.com/Nubisproject/nubis-mediawiki/pull/28) ([tinnightcap](https://github.com/tinnightcap))

- Update parameters-dist file to remove consul params [\#27](https://github.com/Nubisproject/nubis-mediawiki/pull/27) ([tinnightcap](https://github.com/tinnightcap))

- Remoteip and consul bootsrtaping updates [\#26](https://github.com/Nubisproject/nubis-mediawiki/pull/26) ([tinnightcap](https://github.com/tinnightcap))

- Update the readme [\#25](https://github.com/Nubisproject/nubis-mediawiki/pull/25) ([tinnightcap](https://github.com/tinnightcap))

- Remove --debug from readme command [\#24](https://github.com/Nubisproject/nubis-mediawiki/pull/24) ([tinnightcap](https://github.com/tinnightcap))

- Move mappings to project so they can be controled [\#23](https://github.com/Nubisproject/nubis-mediawiki/pull/23) ([tinnightcap](https://github.com/tinnightcap))

- Fix script for nested stack lookups [\#22](https://github.com/Nubisproject/nubis-mediawiki/pull/22) ([tinnightcap](https://github.com/tinnightcap))

- Move memcache logic from cloudformation to php [\#21](https://github.com/Nubisproject/nubis-mediawiki/pull/21) ([tinnightcap](https://github.com/tinnightcap))

- Fluentd improvements [\#20](https://github.com/Nubisproject/nubis-mediawiki/pull/20) ([gozer](https://github.com/gozer))

- Update main.json to use nested stacks [\#19](https://github.com/Nubisproject/nubis-mediawiki/pull/19) ([tinnightcap](https://github.com/tinnightcap))

- Fix update script to use new variable name [\#18](https://github.com/Nubisproject/nubis-mediawiki/pull/18) ([tinnightcap](https://github.com/tinnightcap))

- Parameterizing subnets [\#17](https://github.com/Nubisproject/nubis-mediawiki/pull/17) ([tinnightcap](https://github.com/tinnightcap))

- make sure httpd doesnt create a default vhost on port 80 [\#16](https://github.com/Nubisproject/nubis-mediawiki/pull/16) ([gozer](https://github.com/gozer))

- Add Varnish front-end [\#15](https://github.com/Nubisproject/nubis-mediawiki/pull/15) ([gozer](https://github.com/gozer))

- Add taggs and minor updates [\#14](https://github.com/Nubisproject/nubis-mediawiki/pull/14) ([tinnightcap](https://github.com/tinnightcap))

- Change default theme and logo [\#13](https://github.com/Nubisproject/nubis-mediawiki/pull/13) ([gozer](https://github.com/gozer))

- set IgnoreUnmodifiedGroupSizeProperties otherwise we update on each update [\#12](https://github.com/Nubisproject/nubis-mediawiki/pull/12) ([gozer](https://github.com/gozer))

- Just a small hacky thing to help CI along [\#11](https://github.com/Nubisproject/nubis-mediawiki/pull/11) ([gozer](https://github.com/gozer))

- AutoScaling work for simple Rolling Upgrades on AMI changes [\#10](https://github.com/Nubisproject/nubis-mediawiki/pull/10) ([gozer](https://github.com/gozer))

- Adding tags and minor fixes [\#9](https://github.com/Nubisproject/nubis-mediawiki/pull/9) ([tinnightcap](https://github.com/tinnightcap))

- fix temporary sandbox workaround [\#8](https://github.com/Nubisproject/nubis-mediawiki/pull/8) ([gozer](https://github.com/gozer))

- Make migrate wait for consul keys [\#7](https://github.com/Nubisproject/nubis-mediawiki/pull/7) ([tinnightcap](https://github.com/tinnightcap))

- Add elasticache on top of VPC integration [\#6](https://github.com/Nubisproject/nubis-mediawiki/pull/6) ([tinnightcap](https://github.com/tinnightcap))

- Add conditional logic for non sandbox deployment [\#5](https://github.com/Nubisproject/nubis-mediawiki/pull/5) ([tinnightcap](https://github.com/tinnightcap))

- Make cloudformation do what terraform already does [\#4](https://github.com/Nubisproject/nubis-mediawiki/pull/4) ([tinnightcap](https://github.com/tinnightcap))

- Change to new consul ssl method [\#3](https://github.com/Nubisproject/nubis-mediawiki/pull/3) ([tinnightcap](https://github.com/tinnightcap))

- Breaking CF templates into .d, adding other metadata parameters. Dont wo... [\#2](https://github.com/Nubisproject/nubis-mediawiki/pull/2) ([bhourigan](https://github.com/bhourigan))

- Adding cloudformation templates for nubis-mediawiki [\#1](https://github.com/Nubisproject/nubis-mediawiki/pull/1) ([bhourigan](https://github.com/bhourigan))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*