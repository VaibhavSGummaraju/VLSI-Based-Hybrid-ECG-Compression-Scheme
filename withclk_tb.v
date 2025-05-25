module ecg;
wire [1:0] a;
reg signed [15:0] b;

wire [2:0] k;

wire [7:0] ansr;
wire [9:0] ansg1;
wire [10:0] ansg2;
wire [11:0] ansg3;


reg signed [15:0] x1;
reg signed [15:0] x2;
reg signed [15:0] x3;
reg signed [15:0] x4;
reg signed [15:0] x5;
reg signed [15:0] x6;
reg signed [15:0] x7;
reg signed [15:0] x8;
reg [5:0] cin;
wire [5:0] cout;

reg clk;

abc uut(clk,a,b,k,ansr,ansg1,ansg2,ansg3,x1,x2,x3,x4,x5,x6,x7,x8,cin,cout);
reg signed [15:0] sample_mem [0:21599];
integer compressed_op;

integer i;
integer j;
initial begin

clk = 0;  //initialize the clock

$readmemb("output.txt",sample_mem);
compressed_op = $fopen("compressed_bin.txt","w");

for(i=0;i<21600;i=i+8) begin
	x1 = sample_mem[i];
	x2 = sample_mem[i+1];
	x3 = sample_mem[i+2];
	x4 = sample_mem[i+3];
	x5 = sample_mem[i+4];
	x6 = sample_mem[i+5];
	x7 = sample_mem[i+6];
	x8 = sample_mem[i+7];

	if(i==0) begin
		b=0;
		cin=0;
	end 
	else begin
		b = sample_mem[i-1];
		cin = cout;
	end
	
	for(j = 0; j < 8 ; j = j+1) begin 
		if(ansr != 0)begin
			$fwrite(compressed_op, "%b\n", ansr);
		end
		if(a == 1) begin
			case (k)
				3: $fwrite(compressed_op, "%b\n", ansg1);
				4: $fwrite(compressed_op, "%b\n", ansg2);
				5: $fwrite(compressed_op, "%b\n", ansg3);
            		endcase			
		end
		
		#10;	
	end
    
	    
end
$fclose(compressed_op);

$display("file copy completed");

end
always #10 clk = ~clk;
endmodule
