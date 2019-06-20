$(function(){
  $('.slider').slick({
    infinite: true,
    slidesToShow: 3,
    slidesToScroll: 3,
    prevArrow: '<span class="slide-arrow prev-arrow"><i class="fas fa-chevron-left"></i></span>',
    nextArrow: '<span class="slide-arrow next-arrow"><i class="fas fa-chevron-right"></i></span>',
    responsive: [
      {
        breakpoint: 768,
        settings: {
          slidesToShow: 2,
          slidesToScroll: 2,
        }
      },
      {
        breakpoint: 480,
        settings: {
          slidesToShow: 1,
          slidesToScroll: 1,
        }
      }
    ]
  });
});