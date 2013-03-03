serverPowerManage
=================

Uses
----

- Waking up the local file server at a set time for backups.
- Automatically shutdown the file server if there are no important nodes up on
	the network. (i.e. Desktops and laptops)
- Also can be used for just waking up the file server instead of manually typing
	the `wol` command.

The cron script has been added extra because it provides the functionality of
recording the script output to a log file as well as stdout.