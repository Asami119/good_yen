function search (){
  const resetButton = document.getElementById("reset_btn");
  resetButton.addEventListener("click", (e) => {
    e.preventDefault();
    const date1 = document.getElementById("date1");
    const date2 = document.getElementById("date2");
    const price1 = document.getElementById("price1");
    const price2 = document.getElementById("price2");
    const memo1 = document.getElementById("memo1");
    const memo2 = document.getElementById("memo2");
    const selectYen = document.getElementById("select_yen");
    date1.value="";
    date2.value="";
    price1.value="";
    price2.value="";
    memo1.value="";
    memo2.value="";
    selectYen.checked = true;
  });
};

window.addEventListener('load', search);
