#!/usr/bin/perl

use strict;

$| = 1;

use lib './lib';
use t::lib::Test;
use Test::More tests => 26;
use DBR::Config::Scope;

my $dbr = setup_schema_ok( 'rt_62' );

my $dbrh = $dbr->connect( 'test' );
ok($dbrh, 'dbr connect');

# 2 tests so far, plus tests below

for my $pass (1..2) {      # 2x tests
      diag( "pass $pass:" );

      ok( my $carts = $dbrh->cart->all, "got all carts" );

      while (my $cart = $carts->next) {

            ok( my $items = $cart->items, "got cart items" );
            my $item_count = 0;

            while (my $item = $items->next) {
                  ++$item_count;
                  diag "cart " . $cart->cart_id . ", item " . $item->item_id . ": " . $item->name;
            }

            ok( $item_count == 3, "cart has $item_count items (should have 3)" );
      }

      ok( my $shipments = $dbrh->shipment->all, "got all shipments" );

      while (my $shipment = $shipments->next) {

            ok( my $items = $shipment->items, "got shipment items" );
            my $item_count = 0;

            while (my $item = $items->next) {
                  ++$item_count;
                  diag "shipment " . $shipment->shipment_id . ", item " . $item->item_id . ": " . $item->name;
            }

            ok( $item_count * 100 == $shipment->shipment_id, "shipment " . $shipment->shipment_id . " has $item_count items" );
      }
}

1;

