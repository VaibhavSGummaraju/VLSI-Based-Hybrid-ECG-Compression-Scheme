module abc(output reg [1:0]a,
input signed [15:0] b,

output reg [2:0]k,

output reg [7:0] ansr, 
output reg [9:0] ansg1,
output reg [10:0] ansg2,
output reg [11:0] ansg3,

input signed [15:0] x1,
input signed [15:0] x2,
input signed [15:0] x3,
input signed [15:0] x4,
input signed [15:0] x5,
input signed [15:0] x6,
input signed [15:0] x7,
input signed [15:0] x8,
input [5:0]cin,
output reg [5:0]cout
);

reg signed [15:0] c_array[0:7];
reg signed [15:0] abs_array[0:7];
reg [5:0] ctemp;

integer i;
reg signed [12:0] mean;

reg signed [3:0] qx [0:8];
reg signed [5:0] rx [0:8];
reg signed [15:0] sum;

always @(*) begin

	c_array[0] = x1 - b;
	c_array[1] = x2 - x1;
        c_array[2] = x3 - x2;
        c_array[3] = x4 - x3;
        c_array[4] = x5 - x4;
        c_array[5] = x6 - x5;
        c_array[6] = x7 - x6;
        c_array[7] = x8 - x7;
	sum = 0;
	for (i = 0; i < 8; i = i + 1) begin
            abs_array[i] = (c_array[i][15]==1) ? -c_array[i] : c_array[i]; // Abs without extra variables
            sum = sum + abs_array[i];
        end

	mean = sum >> 3;

	if (mean < 16'd100) begin
		k = 3;
		for(i = 0;i<8;i = i+1)begin
		c_array[i] = c_array[i] / (1<<k);
		qx[i] = c_array[i] / (1<<k);
		rx[i] = c_array[i] % (1<<k);
		end
		// Divide by 8
	end else if (mean < 16'd500) begin
		k = 4;
		for(i = 0;i<8;i = i+1)begin
		c_array[i] = c_array[i] / (1<<k);
		qx[i] = c_array[i] / (1<<k);
		rx[i] = c_array[i] % (1<<k);
		end
		// Divide by 16
	end else begin   
		k = 5;
		for(i = 0;i<8;i = i+1)begin
		c_array[i] = c_array[i] / (1<<k);
		qx[i] = c_array[i] / (1<<k);
		rx[i] = c_array[i] % (1<<k);
		end
		// Divide by 32
	end

	for(i=0;i<8;i=i+1)begin 
		if(qx[i] == 0)begin 
			ctemp = ctemp+1;
			a = 0;		
		end
		else begin
			a=1;
			if(ctemp != 0 )begin 
				//rlc

				ansr[5:0] = ctemp;
				
			end
			//grc
			case (k)
		            3: ansg1 = {2'b01, qx[i][3:0], rx[i][3:0]};
		            4: ansg2 = {2'b10, qx[i][3:0], rx[i][4:0]};
		            5: ansg3 = {2'b11, qx[i][3:0], rx[i][5:0]};
		        endcase
			ctemp = 0;
		end
		#10;
		ansr = 0;
	end

	cout = ctemp;

end
endmodule
