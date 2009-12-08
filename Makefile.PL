

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
                     'bytes' => '1.02',
                     'Carp' => '1.04',
                     'Cwd' => '3.30',
                     'diagnostics' => '1.15',
                     'Digest::MD5' => '2.39',
                     'Encode' => '2.37',
                     'File::Basename' => '2.74',
                     'File::Copy' => '2.09',
                     'File::Path' => '2.07',
                     'File::Spec' => '3.30',
                     'File::Temp' => '0.22',
                     'Getopt::Long' => '2.38',
                     'Pod::Usage' => '1.33',
                     'strict' => '1.03',
                     'Test::More' => '0.94',
                     'vars' => '1.01',
                     'warnings' => '1.05',

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
                     'Text::Corpus::VoiceOfAmerica' => '1.00',
                     'Text::Corpus::VoiceOfAmerica::Document' => '1.0',
                     'URI::Escape' => '3.29',
                     'XML::LibXML' => '1.69',
                     'XML::RSS::Parser' => '4',

                     # list of unknown modules used:
                    },