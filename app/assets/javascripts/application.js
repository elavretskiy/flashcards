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
//= require_tree .

window.onload=function(){
    $('#flickr_search_link').click(function() {
        this.href += '?search=' + $('input[name=flickr_search]').val();
    });

    $('#inlineRadio2').click(function() {
        $('#load_flickr_image').show();
        $('#load_local_image').hide();
        $('#card_image').val('');
    });

    $('#inlineRadio1').click(function() {
        $('#load_flickr_image').hide();
        $('#load_local_image').show();
        $('#remote_image_url input').val('');
    });
}

