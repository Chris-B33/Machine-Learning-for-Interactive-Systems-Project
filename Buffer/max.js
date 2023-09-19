inlets = 1;
outlets = 1;

function list(){
	var nums= arguments;
	var max = 0;
	
	var a = nums[0];
	var b = nums[1];
	var c = nums[2];
	
	if (a > b && a > c) {
		max=1;
	} else if (b > a && b > c) {
		max=2;
	} else if (c > a && c> b) {
		max=3;
	}
	
	post(a,b,c,"\n");
	outlet(0,max);
}