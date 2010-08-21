

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    LICENSE      => 'perl',
    NAME         => 'Text::Corpus::VoiceOfAmerica',
    VERSION_FROM => 'lib/Text/Corpus/VoiceOfAmerica.pm', # finds \$VERSION
    AUTHOR       => 'Jeff Kubina (jeff.kubina@gmail.com)',
    ABSTRACT     => 'Make a corpus of VOA articles for research.',
    PREREQ_PM    => {
                     # list of installed modules used:
                     'CHI' => '0.28',
                     'Data::Dump' => '1.15',
                     'Date::Manip' => '5.54',
                     'HTML::TreeBuilder::XPath' => '0.11',
                     'Lingua::EN::Sentence' => '0.25',
                     'Log::Log4perl' => '1.24',
                     'LWP::Simple' => '5.827',
                     'Path::Class' => '0.16',
                     'Proc::Pidfile' => '1.005',
                     'URI::Escape' => '3.29',
                     'XML::LibXML' => '1.69',
                     'XML::RSS::Parser' => '2.11',
                    },
);

__END__
# Below are the automatically recommended values for PREREQ_PM.
    PREREQ_PM    => {
                     # list of core modules used:
                     'bytes' => '1.04',
                     'Carp' => '1.16',
                     'Cwd' => '3.31',
                     'diagnostics' => '1.19',
                     'Digest::MD5' => '2.40',
                     'Encode' => '2.39',
                     'File::Basename' => '2.78',
                     'File::Copy' => '2.18',
                     'File::Find' => '1.15',
                     'File::Path' => '2.08_01',
                     'File::Spec' => '3.31',
                     'File::Temp' => '0.22',
                     'Getopt::Long' => '2.38',
                     'Pod::Usage' => '1.36',
                     'strict' => '1.04',
                     'Test::More' => '0.96',
                     'utf8' => '1.08',
                     'vars' => '1.01',
                     'warnings' => '1.09',

                     # list of installed modules used:
                     'CHI' => '0.36',
                     'Data::Dump' => '1.17',
                     'Date::Manip' => '6.11',
                     'Forks::Super' => '0.35',
                     'HTML::Encoding' => '0.60',
                     'HTML::TreeBuilder::XPath' => '0.11',
                     'Lingua::EN::Sentence' => '0.25',
                     'Log::Log4perl' => '1.29',
                     'LWP::Simple' => '5.835',
                     'Path::Class' => '0.19',
                     'Proc::Pidfile' => '1.005',
                     'Text::Corpus::VoiceOfAmerica' => '1.02',
                     'Text::Corpus::VoiceOfAmerica::Document' => '1.01',
                     'URI' => '1.54',
                     'URI::Escape' => '3.30',
                     'XML::LibXML' => '1.70',
                     'XML::RSS::Parser' => '4',
                     'XML::Simple' => '2.18',

                     # list of unknown modules used:
                    },