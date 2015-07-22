# Install our standard MOTD on a box
class motd (
  $path = '/etc/motd',
  $display_hostname = true,
  $display_puppet_warning = true,
  $display_qotd = false,
  $contact_email = undef,
  $qotd_text = undef,
  $qotd_author = undef,
  $character = '*',
  $length = 80,
) {

  concat { $path:
    owner => 'root',
    group => 'root',
    mode  => '0644',
  }

  concat::fragment { 'motd_top':
    target  => $path,
    content => inline_template('<% puts @character * @length + "\n" + @character + " " * (#{@length}-2) + @character %>'),
    order   => 02,
  }

  if (is_string($contact_email)) {
    concat::fragment { 'motd_email':
      target  => $path,
      content => inline_template('<% puts @character + ("  Queries about this system to: " + @contact_email).ljust(@length-2,\' \') + @character %>'),
      order   => 04,
    }
  }

  if ($display_hostname) {
  $upfqdn = upcase($::fqdn)
    concat::fragment { 'motd_fqdn':
      target  => $path,
      content => inline_template('<% puts @character + @upfqdn.upcase.center(@length-2,\' \') + @character + "\n" + @character + " " * (@length-2) + @character %>'),
      order   => 03,
    }
  }

  if ($display_puppet_warning) {
    concat::fragment { 'motd_puppet':
      target  => $path,
      content => inline_template('<% puts @character + "  This system is managed by Puppet. Check before editing!".ljust(@length-2,\' \') + @character + "\n" +  @character + " " * (@length-2) + @character %>'),
      order   => 04,
    }
  }

  if ($display_qotd) {
    validate_string($qotd_text)
    validate_string($qotd_author)
    concat::fragment { 'motd_qotd':
      target  => $path,
      content => inline_template('<% puts @character + @qotd.center(length-2,\' \') + @character + "\n" + @character + @qotd_author.rjust(@length-4,\' \') + "  " + @character + "\n" + @character + " " * (@length-2) + @character %>'),
      order   => 04,
    }
  }

  concat::fragment { 'motd_services':
    target  => $path,
    content => inline_template('<% puts @character + "  This server provides the following services:".ljust(@length-2,\' \') + @character %>'),
    order   => 05,
  }

  concat::fragment { 'motd_footer':
    target  => $path,
    content => inline_template('<% puts @character + " " * (@length-2) + @character + "\n" + @character * @length %>'),
    order   => '20',
  }
}
