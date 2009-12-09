package Text::Corpus::VoiceOfAmerica::Document;
use strict;
use warnings;
use Lingua::EN::Sentence qw(get_sentences);
use HTML::TreeBuilder::XPath;
use Date::Manip;

BEGIN {
  use Exporter ();
  use vars qw($VERSION @ISA @EXPORT @EXPORT_OK %EXPORT_TAGS);
  $VERSION = '1.01';
  @ISA     = qw();
  @EXPORT      = qw();
  @EXPORT_OK   = qw();
  %EXPORT_TAGS = ();
}

=head1 NAME

C<Text::Corpus::VoiceOfAmerica::Document> - Parse a VOA article for research.

=head1 SYNOPSIS

  use Cwd;
  use File::Spec;
  use Text::Corpus::VoiceOfAmerica;
  use Data::Dump qw(dump);
  use Log::Log4perl qw(:easy);
  Log::Log4perl->easy_init ($INFO);
  my $corpusDirectory = File::Spec->catfile (getcwd(), 'corpus_voa');
  my $corpus = Text::Corpus::VoiceOfAmerica->new (corpusDirectory => $corpusDirectory);
  $corpus->update (verbose => 1);
  my $document = $corpus->getDocument (index => 0);
  dump $document->getBody;
  dump $document->getCategories;
  dump $document->getContent;
  dump $document->getDate;
  dump $document->getDescription;
  dump $document->getTitle;
  dump $document->getUri;

=head1 DESCRIPTION

C<Text::Corpus::VoiceOfAmerica::Document> provides methods for accessing the
content of VOA news articles for the researching and testing of information processing
techniques. Read the
Voice of America's Terms of Use statement to ensure you abide by it when using this module.


=head1 CONSTRUCTOR

=head2 C<new>

The constructor C<new> creates an instance of the C<Text::Corpus::VoiceOfAmerica::Document>
class with the following parameters:

=over

=item C<htmlContent>

  htmlContent => '...'

C<htmlContent> is a string of the HTML of the document to be parsed.

=item C<uri>

  uri => '...'

C<url> is the URL of the HTML content provided by C<htmlContent>; it is
also returned as the documents unique identifier by C<getUri>.

=back

=cut

# htmlContent => 'html of page' to object.

sub new
{
  my ($Class, %Parameters) = @_;
	my $Self = bless {}, ref($Class) || $Class;
	
  $Self->{htmlParser} = HTML::TreeBuilder::XPath->new;
  $Self->{htmlContent} = $Parameters{htmlContent};

  # i am so lazy sometimes...
  my $htmlContent = $Self->{htmlContent};
#  $htmlContent =~ s|<br>| |g;
#  $htmlContent =~ s|<\/table>|</table>. |g;
  $Self->{htmlParser}->parse($htmlContent);

  # store the doc uri.
  $Self->{uri} = $Parameters{uri} if exists $Parameters{uri};

  return $Self;
}

=head1 METHODS

=head2 C<getBody>

 getBody ()

C<getBody> returns an array reference of strings of sentences that are the body of the article.

=cut

# returns the body of the article.
sub getBody
{
  my $Self = shift;

  # if body already exists, return it now.
  return $Self->{body} if exists $Self->{body};

  my @xpaths;
  push @xpaths, '/html/body/div/table/tr/td/table/tr/td/div/div/span/p';
  push @xpaths, '/html/body/div/table/tr/td/table/tr/td/div/div/span/span';
  push @xpaths, '/html/body/div/table/tr/td/table/tr/td/div/div/div/table/span/span/p';
  push @xpaths, '/html/body/div/table/tr/td/table/tr/td/div/div/div/span/p';
  push @xpaths, '/html/body/div/table/tr/td/table/tr/td/div/span/p';
  push @xpaths, '/html/body/div[2]/div[2]/div[2]/div[@id="mainContent"]/p[(@class!="byline") and (@class!="articleSummary")]';
  #push @xpaths, '/html/body/div[2]/div[2]/div[2]/div/p';


  # get the article content.
  my @linesOfText;
  foreach my $xpathQuery (@xpaths)
  {
    my @nodes=$Self->{htmlParser}->findvalues($xpathQuery);
    foreach my $line (@nodes)
    {
      $line =~ s/Some\s*information\s*for\s*this\s*report\s*was\s*provided\s*by.*?\.//i;
      $line =~ s/\xA0/ /g;
      $line =~ s/^\s+//;
      $line =~ s/\s+$//;
      next unless length ($line);
      my $sentences = get_sentences ($line);
      next unless defined $sentences;
      push @linesOfText, @$sentences;
    }
    last if @linesOfText;
  }

  # return the title and lines of body text.
  $Self->{body} = \@linesOfText;
  $Self->_trim ($Self->{body});
  return $Self->{body};
}

=head2 C<getCategories>

  getCategories ()

C<getCategories> returns an array reference of strings of categories assigned to the article. They are
the phrases and words from the C</html/head/meta[@name="KEYWORDS"]> field in the HTML of the
document.

=cut

sub getCategories
{
  my $Self = shift;
  return $Self->{categories_all} if exists $Self->{categories_all};

  # get the categories.
  my @values = $Self->{htmlParser}->findvalues('/html/head/meta[@name="Keywords"]/@content');
  push @values, $Self->{htmlParser}->findvalues('/html/head/meta[@name="keywords"]/@content');

  my @categories = split (/\,\s*/, join (',', @values));
  $Self->_trim (\@categories);

  # remove duplicative, cache, and return the categories.
  my %uniqueCategories = map {(lc $_, $_)} sort @categories;
  @categories = sort values %uniqueCategories;
  $Self->{categories_all} = \@categories;
  return $Self->{categories_all};
}

=head2 C<getContent>

 getContent ()

C<getContent> returns an array reference of strings of sentences that form the
content of the article, the title and body of the article.

=cut

# returns the body of the article.
sub getContent
{
  my $Self = shift;

  # if content already exists, return it now.
  return $Self->{content} if exists $Self->{content};

  # get the headline.
  my @linesOfText = @{$Self->getTitle};

  # get the article content.
  push @linesOfText, @{$Self->getBody};

  # return the title and lines of body text.
  my $content = \@linesOfText;
  $Self->_trim ($content);
  $Self->{content} = $content;
  return $Self->{content};
}

=head2 C<getDate>

 getDate (format => '%g')

C<getDate> returns the date and time of the article in the format speficied by C<format> that uses the print
directives of L<Date::Manip::Date|Date::Manip::Date/PRINTF_DIRECTIVES>.
The default is to return the date and time in RFC2822 format.

=cut

# return the date of the article
sub getDate
{
  my ($Self, %Parameters) = @_;

  # get the date/time format.
  my $dateFormat = '%g';
  $dateFormat = $Parameters{format} if (exists ($Parameters{format}));

  # if date already exists, return it now.
  return UnixDate ($Self->{date}, $dateFormat) if exists $Self->{date};

  # get the date (for the new format).
  my @values = $Self->{htmlParser}->findvalues('//*[@class="dateStamp"]');
  my $date = undef;
  foreach my $value (@values)
  {
    my $parsedDate = ParseDate ($value);
    if (defined ($parsedDate) && length ($parsedDate))
    {
      $date = $parsedDate;
      last;
    }
  }

  # get the date (for the old format).
 unless (defined $date)
  {
    my @values = $Self->{htmlParser}->findvalues('//*[@class="datetime"]/em');
    foreach my $value (@values)
    {
      my $parsedDate = ParseDate ($value);
      if (defined ($parsedDate) && length ($parsedDate))
      {
        $date = $parsedDate;
        last;
      }
    }
  }

  # return the date.
  $Self->{date} = $date;
  return UnixDate ($Self->{date}, $dateFormat);
}

=head2 C<getDescription>

  getDescription ()

C<getDescription> returns an array reference of strings of sentences, usually one, that
describes the articles content. It is from the C</html/head/meta[@name="description"]>
field in the HTML of the document.

=cut

sub getDescription
{
  my $Self = shift;

  # return the description if already computed.
  return $Self->{description} if exists $Self->{description};

  # get the $description.
  my @descriptions = $Self->{htmlParser}->findvalues('/html/head/meta[@name="Description"]/@content');
  push @descriptions, $Self->{htmlParser}->findvalues('/html/body/div[2]/div[2]/div[2]/div/p[@class="articleSummary"]');
  $Self->_trim (\@descriptions);

  # pull out the sentences.
  my @sentences = ();
  foreach my $description (@descriptions)
  {
    next unless defined $description;
    next unless length $description;
    $description =~ s|<br\s*\/>| |g;
    push @sentences, @{get_sentences ($description)};
  }

  my $description = \@sentences;
  $Self->_trim ($description);
  $Self->{description} = $description;
  return $Self->{description};
}

=head2 C<getTitle>

 getTitle ()

C<getTitle> returns an array reference of strings, usually one, of the title of the article.

=cut

# returns the title of the article.
sub getTitle
{
  my $Self = shift;

  # if title already exists, return it now.
  return $Self->{title} if exists $Self->{title};

  # get the print headline.
  my @titleLines = $Self->{htmlParser}->findvalues('/html/body/div/table/tr/td/table/tr/td/div/div/table/tr/td/span[@class="articleheadline"]');
  push @titleLines, $Self->{htmlParser}->findvalues('/html/body/div[2]/div[2]/div[2]/div/h2');

  # return the title and lines of body text.
  $Self->{title} = \@titleLines;
  $Self->_trim ($Self->{title});
  return $Self->{title};
}

=head2 C<getUri>

  getUri ()

C<getUri> returns the URL of the document.

=cut

sub getUri
{
  my $Self = shift;
  return $Self->{uri};
}

# trims off white space from the beginning and end of a string.
sub _trim
{
  my $Self = shift;
  my $TextLinesToTrim = shift;
  foreach my $line (@$TextLinesToTrim)
  {
    $line =~ s/^\s+//;
    $line =~ s/\s+$//;
  }
  return undef;
}

# need to call delete on html treebuilder so we have to implement
# DESTROY for object.
sub DESTROY
{
  my $Self = shift;
  $Self->{htmlParser}->delete if exists $Self->{htmlParser};
  undef $Self;
}

=head1 INSTALLATION

For installation instructions see L<Text::Corpus::VoiceOfAmerica>.

=head1 AUTHOR

 Jeff Kubina<jeff.kubina@gmail.com>

=head1 COPYRIGHT

Copyright (c) 2009 Jeff Kubina. All rights reserved.
This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

The full text of the license can be found in the
LICENSE file included with this module.

=head1 KEYWORDS

information processing, english corpus, voa, voice of america

=head1 SEE ALSO

=begin html

Read the <a href="http://author.voanews.com/english/disclaim.cfm">Voice of America's Terms of Use</a> statement to ensure you abide by it
when using this module.

=end html

L<CHI>, L<HTML::TreeBuilder::XPath>, L<Lingua::EN::Sentence>, L<Log::Log4perl>, L<Text::Corpus::VoiceOfAmerica>

=cut

1;
# The preceding line will help the module return a true value

