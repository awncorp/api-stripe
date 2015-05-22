package API::Stripe::Class;

use Extorter;

# VERSION

sub import {
    my $class  = shift;
    my $target = caller;

    $class->extort::into($target, '*Data::Object::Class');
    $class->extort::into($target, '*API::Stripe::Signature');
    $class->extort::into($target, '*API::Stripe::Type');

    return;
}

1;
