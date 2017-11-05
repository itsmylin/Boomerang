// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .
//= stub_tree page_specific
//= require_tree ../../../vendor/assets/javascripts

// Ali: I removed the following line so that not all JS file get called
// to iprove the performance

// If you need a page-specific page JS: create a directory (e.g. mood)
// add your JS files to /mood
// in the source file (e.g. views/mood/index.html.erb) add this:
// <%= javascript_include_tag 'mood/mood'%>
// to include that JS specifically in this page-specific
// if you need app-specific JS ( for all or most pages)
// add it to another directory (e.g. app)
// add this:
