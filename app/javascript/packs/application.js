require('@rails/ujs').start()
require('@rails/activestorage').start()
require('channels')
require("jquery")
require("@nathanvda/cocoon")
require.context('../packs/js', true)

import 'popper.js';
import '../stylesheets/application';
import '../packs/bootstrap/dist/js/bootstrap';

import $ from 'jquery';
import 'select2';
import 'select2/dist/css/select2.css';

$(() => {
  $('#summary_source_columns').select2({
    placeholder: 'Select Options',
    multiple: true
  });

  $('#summary_destination_columns').select2({
    placeholder: 'Select Options',
    multiple: true
  });

  $('#summary_result_columns').select2({
    placeholder: 'Select Options',
    multiple: true
  });
});
