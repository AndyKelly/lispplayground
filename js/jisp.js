
var functionNameIndex = 1;
var functionInputIndex = 2;
var functionDefinitionIndex = 3;

var atomic = ['-','+','*','/']
var bool = ['and','xor', 'or', "eq"]

var boolMap = {
  "and" : '&&',
  "xor" : '^',
  "or" : '||',
  "eq" : '===',
}

var operational = ['print'];
var creational = ['defun']

var operationalMap = {
  'print' : function(arg){
    console.log(arg);
  }
}

var creationalMap = {
  'defun' : function(args){
    operational[args[functionNameIndex]] = function(_args){
      //JSON.stringify(_args).replace('par', args[1])
      return parse(args.splice(1, args.length))
    }
  }
}

function ssAtomic(args){
  var op = args[0];
  var cur = args[1];
  for (var i = 2; i < args.length; i++) {
    var exec = 'cur = '+ cur + op +" " + args[i]
    //console.log('Executing:' + exec);
    eval(exec)
  };
  return cur
}

function ssBoolean(args){
  var op = boolMap[args[0]];
  var cur = args[1];
  var execStr = ''
  for (var i = 2; i < args.length; i++) {
    execStr += " " + cur + " " + op +" " + args[i]
  };
  console.log(execStr);
  return eval(execStr)
}

function ssOperational(args){
  var op = operationalMap[args[0]];
  for (var i = 1; i < args.length; i++) {
    op(args[i])
  };
}

function parseToken(tokenName, args){
  if(typeof tokenMap[tokenName] === 'function'){
    return tokenMap[tokenName](args)
  }else{
    return args
  }
}

function parse(ast){
  var arrIndexes = []
  for (var i = 0; i < ast.length; i++) {
    if( Object.prototype.toString.call( ast[i] ) === '[object Array]' ){
      ast[i] = parse(ast[i]) 
    }
  }
  if(atomic.indexOf(ast[0]) > -1){
    return ssAtomic(ast)
  }else if(bool.indexOf(ast[0]) > -1){
    return ssBoolean(ast)
  }else if(operational.indexOf(ast[0]) > -1){
    return ssOperational(ast)
  }else if(creational.indexOf(ast[0]) > -1){
    return ssCreational(ast)
  }
}

var multiple = ['+',3,4,2]
console.log(parse(multiple));

var simple = ['*', 2, 3]
console.log(parse(simple));

var simple = ['-', 4, 3]
console.log(parse(simple));

var simple = ['+', ['+', 2, 3], 3]
console.log(parse(simple));

var simple = ['-', 1]
console.log(parse(simple));

var testCase = ['-', 100,['+',3,['*', 2, 4]]]
console.log(parse(testCase));

var testCase = ['-', 100,['+',3,['*', 2, ['-', 7, 8], 9, 4]]]
console.log(parse(testCase));

var testCase = ['eq', 169, ['-', 100,['+',3,['*', 2, ['-', 7, 8], 9, 4]]]]
console.log(parse(testCase));

var testCase = ['print',  'Should be true', ['eq', 2, ['-', 100,['+',3,['*', 2, ['-', 7, 8], 9, 4]]]]]
parse(testCase);

parse(['print', ['and', ['eq',['-', 5, 10],-5], true]])



parse(['defun', ['something'], ['and', ['eq',['-', 5, 'par'],-5], true]])

parse(['something', '5'])