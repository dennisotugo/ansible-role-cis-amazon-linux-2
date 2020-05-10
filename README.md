# ansible-role-cis-amazon-linux-2
## Continued from https://github.com/anthcourtney/ansible-role-cis-amazon-linux but for Amazon Linux 2

Development
-------------
We are going to use "master" branch only for fully tested changes.

**Going forward please send your pull requests to "build" branch.**

We need more community support to make changes and most importantly to test and review changes. If you would like to participate, please send a note to [Anth](https://github.com/anthcourtney) or [Chandan](https://github.com/chandanchowdhury).

The major work to be done are
* CIS Benchmark v2.2.0
* Ansible 2.5 and above
* Amazon Linux 2 LTS

Introduction
------------

This ansible role applies v2.0.0 of the CIS Amazon Linux Benchmark. <https://www.cisecurity.org/benchmark/amazon_linux/>

This role was developed and tested against Amazon Linux 2. It has been tested against Amazon Linux 2 with equal success.

Why Would I Use This Role?
--------------------------

If you are attempting to obtain compliance against an industry-accepted security standard, like PCI DSS, APRA or ISO 27001, then you need to demonstrate that you have applied documented hardening standards against all systems within scope of assessment.

If you are running Amazon Linux, then this role attempts to provide one piece of the solution to the compliance puzzle.

Here Be Dragons!
----------------

If you are considering applying this role to any servers, you should have a basic familiarity with the CIS Benchmark (or other similar benchmarks) and an appreciation for the impact that it may have on a system.

Please take the time to familarise yourself with the standard and with the configurable default values, and exclude any items before applying to a system.

An examples of items that should be immediately considered for exclusion (or at least, for modification of the related default values) include:

* ```3.3.2``` and ```3.3.3```, which by default effectively limit access to the host (including via ssh) to localhost only.


Example Playbook
----------------

An example playbook which uses this role is as follows:

```
---

- hosts: localhost
  connection: local
  gather_facts: true
  become: yes

  roles:
    - ansible-role-cis-amazon-linux-2.cis-amazon-linux
```

A more advanced example, which includes modifications to the default values used, as well as the exclusion of some items in the benchmark which are considered unnecessary for a fictional environment, is as follows:

```
---

- hosts: localhost
  connection: local
  gather_facts: true
  become: yes

  vars:
    ntp_servers:
      - 0.amazon.pool.ntp.org
      - 1.amazon.pool.ntp.org
      - 2.amazon.pool.ntp.org
      - 3.amazon.pool.ntp.org
    cis_level_1_exclusions:
    # Allows packer scripts to build by enabling /tmp
      - 1.1.2
      - 1.1.3
      - 1.1.4
      - 1.1.5
    # Autofs is no longer installed and we need to ignore it or else will fail	
      - 1.1.19
    # Using Chronyd instead of NTP	
      - 2.1.1.2	
    # Using Samba	
      - 2.1.12
    # LDAP
      - 2.2.5
    # Firewall rules and locks us out at a point
      - 3.1.1
      - 3.3.2
      - 3.3.3
      - 3.5.1.1
      - 3.5.1.4
      - 3.5.2.1
    # Disable remote logging
      - 4.2.1.4
    # Disabled SU group restriction
      - 5.5
    cis_level_2_exclusions:
      - 6.1.1
    cis_pass_max_days: 45
    cis_umask_default: 002

  roles:
    - ansible-role-cis-amazon-linux-2.cis-amazon-linux

```

Note that the use of ```become: yes``` is required as 99% of tasks require privileged access to execute.

Role Variables
--------------

See ```defaults/main.yml``` for variables which can be overriden according to preference.

Options
-------

Tags (and combinations thereof) can be used to run a particular level of the CIS standard, a section, or an individual recommendation. For example:

* Run only Level 1 tasks

```
ansible-playbook playbook.yml -t level-1
```

* Run only Section 3 tasks

```
ansible-playbook playbook.yml -t section-3
```

* Run tasks 1.3.1 and 2.2.10 only

```
ansible-playbook playbook.yml -t 1.3.1,2.2.10
```

* Run scored tasks only

```
ansible-playbook playbook.yml -t scored
```

Limitations
-----------

At present, only the Level 1 items of the benchmark are implemented. Level 2 items will be added as time permits.

The following checks have not been implemented:

* 3.6.2. Firewall rulesets are environment specific.
* 3.6.3. Firewall rulesets are environment specific.
* 3.6.4. Firewall rulesets are environment specific.
* 3.6.5. Firewall rulesets are environment specific.
* 4.2.1.3. Inline editing of rsyslog configuration file is considered too imprecise and is best solved by a supplied configuration file which addresses this and other related requirements.
* 4.2.1.4. Inline editing of rsyslog configuration file is considered too imprecise and is best solved by a supplied configuration file which addresses this and other related requirements.
* 4.2.1.5. Inline editing of rsyslog configuration file is considered too imprecise and is best solved by a supplied configuration file which addresses this and other related requirements.
* 4.3. The configuration of logrotate is site-specific.

Compatibility
-------------

This role is compatible with the following versions of ansible:

* 2.3
* 2.4
* 2.5
* 2.6
* 2.7

This role has not been tested against any other versions of ansible.

Testing
-------

The following testing processes are applied by the developer of this role:

* The syntax of the role is checked. See ```make syntax```.
* ```ansible-review``` is run against the role and any warnings which are deemed appropriate are remediated. See ```make review```.
* The role is applied against a docker container using both ansible v2.1.3 and ansible v2.2. see ```make test```.

The following tests have been flagged but are not yet implemented:

* Test application of the role against the Vagrant ```mvbcoding/awslinux``` image, using the ansible provisioner.

Author Information
------------------

This role was developed from [Anth Courtney](https://au.linkedin.com/in/anthcourtney) original github publication.

All feedback, issues and PRs are encouraged and appreciated.
