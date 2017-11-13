unit datemanagement;
//unit pengolahan waktu dan tanggal dalam program

interface
	
	uses typeandvar;
	
	function isKabisat(x : integer) : boolean;
	//menghasilkan true apabila tahun merupakan tahun kabisat
	function is31(x:integer):boolean;
	function faktor31(x,y,z:integer):integer;
	{fungsi untuk menghitung faktor31 artinya tambahan waktu atau pengurangan waktu per bulan dari asumsi normal 30 hari}
	//x adalah bulan yang lebih awal(titik acuan)
	//y adalah bulan saat ini
	//z adalah tahun saat ini
	//misalnya ingin mengetahui berapa kali melewati bulan yaang berhari 31
	//tglpembuatan=12 Februari 2017
	//jatuh tempo=21 Mei 2017
	//x=2
	//y=5
	//z=2017
	//faktor31 = -1+1=0
	function selisihwaktu(x,y:tanggal):integer;
	//menghitung selisih waktu dalam bentuk hari
	//y waktu yang lebih akhir
	//x waktu lebih awal
	function efekKabisat(x,y:tanggal):integer;
	function convMonth(m:word):string;
	{I.S m terdefinisi}
	{F.S menghasilkan nama bulan sesuai angka pada m}

	
implementation

	function isKabisat(x : integer) : boolean;
		begin
			if ((x mod 400)=0)then
			begin
				isKabisat := True;
			end else //x tidak habis dibagi 400
			begin
				if ((x mod 100)=0) then
				begin
					isKabisat := False;
				end else //x tidak habis dibagi 100
				begin
					if ((x mod 4)=0) then
					begin
						isKabisat := True;
					end else isKabisat := False; //x tidak habis dibagi 4
				end;
			end;
		end;
		
	function is31(x:integer):boolean;
	begin
		if(x=1) or (x=3) or (x=5) or (x=7) or (x=8) or (x=10) or (x=12) then
		begin
			is31:=True
		end else
			is31:=False;
	end;

	function faktor31(x,y,z:integer):integer;
	begin
		faktor31:=0;
		if(x<y) then
		begin
			for i:=x to y-1 do
			begin
				if(i=1)or(i=3)or(i=5)or(i=7)or(i=8)or(i=10)or(i=12) then
				begin
					faktor31:=faktor31+1;
				end;
				if(i=2)then
				begin
					faktor31:=faktor31-1;
					if(not(isKabisat(z))) then
					begin
						faktor31:=faktor31-1
					end;
				end;
			end;
		end else
		if(x>y) then
		begin
			for i:=y-1 downto 0 do
			begin
				if(i=1)or(i=3)or(i=5)or(i=7)or(i=8)or(i=10)or(i=12) then
				begin
					faktor31:=faktor31+1;
				end;
				if(i=2) then
				begin
					faktor31:=faktor31-1;
					if(isKabisat(z)) then
					begin
						faktor31:=faktor31-1
					end;
				end;
			end;
			for i:=12 downto x do
			begin
				if(i=1)or(i=3)or(i=5)or(i=7)or(i=8)or(i=10)or(i=12) then
				begin
					faktor31:=faktor31+1;
				end;
				if(i=2) then
				begin
					faktor31:=faktor31-1;
					if(not(isKabisat(z))) then
					begin
						faktor31:=faktor31-1
					end;
				end;
			end;
		end;
	end;
	
	function efekKabisat(x,y:tanggal):integer;
	begin
		efekKabisat:=0;
		for i:=x.YY to y.YY do
		begin
			if(isKabisat(i)) then
			begin
				efekKabisat:=efekKabisat+1;
			end;
		end;
	end;
	
	
	function selisihwaktu(x,y:tanggal):integer;
	begin
		selisihwaktu:=(y.YY-x.YY)*365+(y.MM-x.MM)*30+(y.DD-x.DD)+faktor31(x.MM,y.MM,y.YY)+efekKabisat(x,y);
	end;

	
	function convMonth(m:word):string;
	begin
		case m of
			1:convMonth:='Januari';
			2:convMonth:='Februari';
			3:convMonth:='Maret';
			4:convMonth:='April';
			5:convMonth:='Mei';
			6:convMonth:='Juni';
			7:convMonth:='Juli';
			8:convMonth:='Agustus';
			9:convMonth:='September';
			10:convMonth:='Oktober';
			11:convMonth:='November';
			12:convMonth:='Desember';
		end;
	end;
	
END.
	
