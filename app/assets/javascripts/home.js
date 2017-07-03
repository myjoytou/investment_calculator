// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://coffeescript.org/

(function(window) {
  $(document).ready(function() {
    // var investmentObj = {scheme_code: '', investedValue: ''};
    var investments = [];
    var currentSchemeCode = "";
    var currentDate = "";
    var fundId = "";
    var formCounter = 1;
    var funds = "";
    var addForm = $.Deferred();

    $( "#date"+formCounter ).datepicker({ minDate: new Date(2015, 4 - 1, 1), maxDate: new Date() }).datepicker( "option", "dateFormat", "yy-mm-dd" );

    function calculateInvestment(investments) {
      $.get('/home/calculate_investment', { investments: investments, fund_id: fundId })
        .done(function(data) {
          console.log('the vlaue si: ', data.total_investment_value);
          alert('Your total investment value is '+ data.total_investment_value.toString());
        })
        .fail(function(error) {
          alert(error.responseJSON.error);
        });
    }

    function addFormToDiv(funds) {
      $appWrapper = $("#app-wrapper");
      var formString = "<div class='col-md-12'>";
      formString += "<div class='col-md-4'>";
      formString += "<label for='fund"+ formCounter + "'>Select Fund: </label>";
      formString += "<select id='fund"+ formCounter + "'>";
      formString += "<option value=''></option>";
      if (funds.length > 0) {
        for (var i = 0, size = funds.length; i < size; i++) {
          formString += "<option value=" + funds[i].id + ">" + funds[i].name + "</option>";
        }
      }
      else {
        alert("there was some error while processing your request");
        return;
      }
      formString += '</select>';
      formString += '</div>';
      formString += '<div id="schemes-div'+ formCounter +'" class="col-md-4"></div>';
      formString += '<div id="date-div' + formCounter +'" class="col-md-4"><label for="date">Select Date:</label><input id="date' + formCounter + '" type="text" name=""></div>';
      formString += '<div id="investment-div' + formCounter +'" class="col-md-4"><label for="investment">Enter Investement Amount:</label><input type="text" id="investment' + formCounter + '" /></div>';
      formString += '<div id="units-div' + formCounter +'" class="col-md-4"><label for="">Units:</label></div>';
      formString += '<button class="btn btn-info" id="addForm' + formCounter +'">&#43;</button>'
      $appWrapper.append(formString);

      $( "#date"+formCounter ).datepicker({ minDate: new Date(2015, 4 - 1, 1), maxDate: new Date() }).datepicker( "option", "dateFormat", "yy-mm-dd" );

      $('#fund'+formCounter).on('change', function(event) {
        fundId = event.target.value;
        getSchemes(fundId);
      });

      $("#investment"+formCounter).on('change', function(event) {
        var investmentAmount = event.target.value;
        var investmentObj = {scheme_code: currentSchemeCode, invested_amount: investmentAmount, date: currentDate, fund_id: fundId};
        investments.push(investmentObj);
        populateUnits(investmentObj);
        console.log('the value is: ', investments);
        // console.log('the current schema code is: ', currentSchemeCode);
      });

      $("#date"+formCounter).on('change', function(event) {
        currentDate = event.target.value;
      });

      $("#addForm"+formCounter).on('click', function() {
        getMutualFunds();
      });
    }


    function getMutualFunds() {
      $.get('/home/mutual_funds.json')
        .done(function(data) {
          addFormToDiv(data.funds)
        })
        .fail(function(error) {
          alert(error.responseJSON.error);
        })
    }

    function populateUnits(investmentObj) {
      $.get('/home/calculate_units.json', investmentObj)
        .done(function(data) {
          var str = '<label for="">Units:</label><span>' + data.units + '</span>';
          $("#units-div"+formCounter).html(str);
          investmentObj.units = data.units;
          investments.push(investmentObj);
          console.log('the investments are: ', investments);
        })
        .fail(function(error) {
          alert(error.responseJSON.error);
        });
    }

    function createSchemeSelectionBox(schemes) {
      console.log('the schemes is: ', schemes);
      $schemeDiv = $("#schemes-div"+formCounter);
      $schemeDiv.append("<label for='schemes'> Select Schemes </label>");
      selectionBoxString = "<select id='schemes" + formCounter + "'>";
      selectionBoxString += "<option value=''></option>";
      for (var i = 0, size = schemes.length; i < size; ++i) {
        selectionBoxString += "<option value=" + schemes[i].scheme_code + ">" + schemes[i].scheme_name + "</option>";
      }
      selectionBoxString += "</select>";
      $schemeDiv.append(selectionBoxString);
      $("#schemes"+formCounter).on('change', function(event) {
        currentSchemeCode = event.target.value;
      });
    }

    function getSchemes(fundId) {
      $.get('/home/get_schemes.json', {fund_id: fundId})
        .done(function(data) {
          createSchemeSelectionBox(data.schemes);
        })
        .fail(function(error) {
          alert(error.responseJSON.error);
        });
    }

    $('#fund'+formCounter).on('change', function(event) {
      fundId = event.target.value;
      getSchemes(fundId);
    });

    $("#investment"+formCounter).on('change', function(event) {
      var investmentAmount = event.target.value;
      var investmentObj = {scheme_code: currentSchemeCode, invested_amount: investmentAmount, date: currentDate, fund_id: fundId};
      populateUnits(investmentObj);
      console.log('the value is: ', investments);
      // console.log('the current schema code is: ', currentSchemeCode);
    });

    $("#date"+formCounter).on('change', function(event) {
      currentDate = event.target.value;
    });

    $("#addForm"+formCounter).on('click', function() {
      formCounter++;
      getMutualFunds();
    });

    $('#investment-calc').on('click', function() {
      calculateInvestment(investments);
    });
  });
}(window));
