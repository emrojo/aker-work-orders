// Used to show the selected product and cost infomation in 'Select Product' step

$(document).on("turbolinks:load", function() {

  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  $('#product-select').change(function(event){
    var productId = $("#product-select").val();
    var workOrderId = $("#work-order-id").val();

    $.ajax({
      url: Routes.root_path()+'api/v1/work_orders/'+workOrderId+'/products/'+productId,
      method: 'GET',
      dataType: 'json',
      contentType: 'application/json',
      success: function(data){
        renderProductInformation(data);
        renderCostInformation(data);
        renderDefaultProductDefinition(data);
      },
      error: function() {
        renderError('There was an error while accessing the Billing service');
      }
    });
  });
});

function renderError(msg) {
  var errorMsg = '<div class="alert-danger alert alert-dismissible" role="alert">'+msg+'</div>';
  $("#flash-display").html(errorMsg);
}

function renderDefaultProductDefinition(data) {
  // mocking the database
  var path = getProductData();
  var productOptions = '';
  if (path) {
     productOptions = createProductDefinition(path);
  }
  $('#product-definition').html(productOptions);
  $('#product-definition').show();

  createSelectListeners();
}

function createProductDefinition(path) {
  var selectHtml = '<label>Choose options:</label><br>';
  for (var i = 0; i < path.length; ++i) {
    var defaultKey;
    i == 0 ? defaultKey = 'start' : defaultKey = path[i-1];
    var options = availableLinks[defaultKey];
    selectHtml += createSelectElement(options, path[i], i);
    if (i < path.length-1) {
      selectHtml += '\u27a1';
    }
  }
  return selectHtml;
}

function createSelectElement(options, defaultOption, selectNumber) {
  var selectString = "<select style='width:200px' id='select"+selectNumber+"'>";
  if (typeof(options) == 'string') {
    selectString += "<option>" + options + "</option>";
  } else {
    for (var i = 0; i < options.length; ++i) {
      if (defaultOption == options[i]) {
        selectString += "<option selected>" + options[i] + "</option>";
      } else {
        selectString += "<option>" + options[i] + "</option>";
      }
    }
  }
  selectString += '</select>';
  return selectString;
}

function createSelectListeners(){
  var productDefinition = $('#product-definition')[0];
  var numOfSelects = productDefinition.childElementCount
  for (var i = 0; i < numOfSelects; ++i) {
    $("#select"+i).change(function(){
      var newValue = $("#select"+i).val();
      onSelectChange(i, newValue);
    });
  }
}

function onSelectChange(selectId, newValue){
  var newPath = getProductData().slice(0);
  newPath[selectId] = newValue;
  var productOptions = createProductDefinition(newPath);

  $('#product-definition').html(productOptions);
  $('#product-definition').show();
  createSelectListeners();
}

function renderProductInformation(data) {
  var product = {
    cost_per_sample: convertToCurrency(data.unit_price),
    requested_biomaterial_type: data.requested_biomaterial_type,
    product_version: data.product_version,
    tat: data.TAT,
    description: data.description,
    availability: data.availability,
    product_class: data.product_class,
  };
  var result = JST['templates/product'](product);

  $('#product-information').html(result);
  $('#product-information').show();
}

function renderCostInformation(data) {
    var numOfSamples = $("#product-select").attr('num_of_samples');
    var costPerSample = data.unit_price;
    var total = numOfSamples * costPerSample;

    var cost = {
      num_of_samples: numOfSamples,
      cost_per_sample: convertToCurrency(costPerSample),
      total: convertToCurrency(total)
    }
    var result = JST['templates/cost'](cost);

    $('#cost-information').html(result);
    $('#cost-information').show();
}

function convertToCurrency(input) {
  if (typeof(input)=='string') {
    input = parseInt(input)
  }
  return '£' + input.toFixed(2);
};

function getProductData() {
  var defaultPath = '';
  var selectedProduct = $('#product-select option:selected')[0].text;
  if (selectedProduct == "Quality Control"){
    defaultPath = ['Quantification','Genotyping HumGen SNP'];
    availableLinks = {
      'start': ['Genotyping CGP SNP','Genotyping DDD SNP','Genotyping HumGen SNP','Quantification'],
      'Genotyping CGP SNP': 'end',
      'Genotyping DDD SNP': 'end',
      'Genotyping HumGen SNP':'end',
      'Quantification': ['Genotyping CGP SNP','Genotyping DDD SNP','Genotyping HumGen SNP'],
    }
  }
  return defaultPath;
}