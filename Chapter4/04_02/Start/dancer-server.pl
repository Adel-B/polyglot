use Dancer;
use MongoDB;

my $client = MongoDB->connect();
my $quotes = $client->get_database('test')->get_collection('quotes');

get '/api/quotes' => sub {
    my $response = $quotes->find()->sort({'index' => -1})->limit(10);
    my @results = ();
    while(my $quote = $response->next) {
                push (@results,
                        {"content" => $quote->{'content'},
                         "index"   => $quote->{'index'},
                         "author"  => $quote->{'author'}
                         }
                );
        } 
        if (! scalar (@results)) {
            status 404;
            return;
        }
        return \@results;
};

get '/api/quotes/:index' => sub {
    my $response = $quotes->find_one({"index" => int(params->{'index'})}); 
    if (!$response) {
        status 404;
        return;
    }
    return $response;
};


get '/' => sub{
    return {message => "Hello from Perl and Dancer"};
};

set public => path(dirname(__FILE__), '..', 'static');

get "/demo/?" => sub {
    send_file '/index.html'
};

dance;

