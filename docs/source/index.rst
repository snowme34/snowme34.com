.. Docsnt documentation master file, created by
   sphinx-quickstart on Fri Oct 26 17:59:14 2018.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

Docsnt
==================================

Docsnt (pronounce as "doc sent") is just a combination of "doc" and my name,
`snowme34 <https://www.snowme34.com>`_.

This is a personal web page using `Readthedocs <https://readthedocs.org/>`_
and `Sphinx <http://www.sphinx-doc.org/>`_ documenting something fun (I think)
to share.

Please refer to the table of contents below and in the sidebar for your topic
of interest. You can also use the search function in the top left corner.

Also this site supports https, open "https://docs.snowme34.com" if you address bar
shows an http.

.. note:: This is a personal wiki-like place. There is no guarantee about anything.
          Please `contact me`_ if you spot any errors. You can also create an issue
          on the `repo`_.

.. _contact me: https://contact.snowme34.com
.. _repo: https://github.com/snowme34/snowme34.com

Featured
^^^^^^^^

Some featured pages:

* to learn about the Linux commands, read the
  `Unix and Linux Commands <reference/commands/unix-and-linux-commands>`_
* to see how easy setting up `iptables` and `neftables` for Debian is, read the
  `Debian Firewall nftables and iptables
  <reference/devops/debian-firewall-nftables-and-iptables>`_
* to see a huge collection of interesting website, read the
  `Cuddly Links Collection <links/cuddly_links_collection>`_
* to learn about red black trees, read the
  `Red Black Tree
  <algorithms-and-data-structures/red-black-tree/red-black-tree>`_

Contents
^^^^^^^^

The organization of this site is as following:

.. toctree::
   :maxdepth: 1
   :caption: General
   :name: sec-general

   about/index


.. toctree::
   :maxdepth: 1
   :caption: Algorithms and Data Structures
   :name: sec-algorithms-and-data-structures

   algorithms-and-data-structures/red-black-tree/red-black-tree


.. toctree::
   :maxdepth: 1
   :caption: Command Reference
   :name: sec-reference-command

   reference/commands/unix-and-linux-commands
   reference/commands/windows-commands
   reference/commands/docker-commands
   reference/commands/git-commands
   reference/commands/vim-commands


.. toctree::
   :maxdepth: 1
   :caption: DevOps Reference
   :name: sec-reference-devops

   reference/devops/set-up-debian-server-on-digital-ocean
   reference/devops/debian-firewall-nftables-and-iptables


.. toctree::
   :maxdepth: 1
   :caption: Unix Reference
   :name: sec-reference-unix

   reference/unix/unix-permissions
   reference/unix/unix-user-and-group
   reference/unix/disk-basics
   reference/unix/unix-disk-management
   reference/unix/unix-file-system
   reference/unix/mount-and-unmount
   reference/unix/unix-network-config


.. toctree::
   :maxdepth: 1
   :caption: Network Reference
   :name: sec-reference-network

   reference/network/network-devops-basic


.. toctree::
   :maxdepth: 1
   :caption: Natural Languages - Japanese
   :name: sec-natural-lang-jp

   natural-languages/nihongo/Japanese-Give-and-Receive
   natural-languages/nihongo/Japanese-Verb-Forms-Short-Summary


.. toctree::
   :maxdepth: 1
   :caption: Links
   :name: sec-links

   links/cuddly_links_collection

.. Indices and tables
.. ==================
.. 
.. * :ref:`genindex`
.. * :ref:`modindex`
.. * :ref:`search`