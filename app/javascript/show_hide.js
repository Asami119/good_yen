function show_hide (){
  const target = document.querySelector('.target');
  const show_hide_btn = document.getElementById('show_hide');
  show_hide_btn.addEventListener("click", () => {
    target.classList.toggle('is-hidden')
  });
};

window.addEventListener('load', show_hide);
