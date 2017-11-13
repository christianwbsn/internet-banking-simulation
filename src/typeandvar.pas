unit typeandvar;
//Spesifikasi: Unit yang merupakan kumpulan variabel dan type bentukan yang akan digunakan pada pemrosesan dalam program

interface
	uses sysutils,dos;

	function L0(w:word):string;//pemrosesan tampilan jam agar tetap dua digit
	{I.S w terdefinisi}
	{F.S menampilkan angka 0 di depan angka jam/menit apabila <10}

	const
		Nmax = 20;//nilai konstanta maksimum
		f1:string = 'rekening.txt';//f1 hingga f8 adalah konstanta untuk pengisian namafile eksternal
		f2:string = 'nasabah.txt';
		f3:string = 'transaksi.txt';
		f4:string = 'transfer.txt';
		f5:string = 'pembayaran.txt';
		f6:string = 'pembelian.txt';
		f7:string = 'tukarmatauang.txt';
		f8:string = 'listbarang.txt';
		c1:string = 'load';//c1 hingga c8 adalah konstanta untuk perintah fitur yang ada
		c2:string = 'login';
		c25:string = 'logout';
		c3:string = 'lihatrekening';
		c4:string = 'informasisaldo';
		c5:string = 'lihataktivitastransaksi';
		c6:string = 'pembuatanrekening';
		c7:string = 'setoran';
		c8:string = 'penarikan';
		c9:string = 'transfer';
		c10:string = 'pembayaran';
		c11:string = 'pembelian';
		c12:string = 'penutupanrekening';
		c13:string = 'perubahandatanasabah';
		c14:string = 'penambahanautodebet';
		c15:string = 'exit';
		
	type
		//type record untuk pemrosesan tanggal
		Tanggal = Record
			DD : Integer;
			MM : Integer;
			YY : Integer;
		end;
		//Data rekening online
		rekening = record
			noAkun : string;
			noNasabah : string;
			jenisRek : string;
			mataUang : string;
			saldo : longint;
			setoran : longint;
			rekAutodebet : string;
			jangkaWaktu : string;
			tglTransaksi : Tanggal;
		end;
		//Data Nasabah
		nasabah = record
			noNasabah : string;
			nama : string;
			alamat : string;
			kota : string;
			email : string;
			noTelp : string;
			username : string;
			password : string;
			status : string;
		end;
		//Data Transaksi setor dan tarik
		transaksi = record
			noAkun : string;
			jenisTrans : string;
			mataUang : string;
			jumlah : longint;
			saldo : longint;
			tglTransaksi : Tanggal;
		end;
		//Data transaksi transfer
		transTransfer = record
			noAkunAsal : string;
			noAkunTujuan : string;
			jenis : string;
			namaBankLuar : string;
			mataUang : string;
			jumlah : longint;
			saldo : longint;
			tglTransaksi : Tanggal;
		end;
		//Data Transaksi Pembayaran
		pembayaran = record
			noAkun : string;
			jenis : string;
			rekBayar : string;
			mataUang : string;
			jumlah : longint;
			saldo : longint;
			tglTransaksi : Tanggal;
		end;
		//Data Transaksi Pembelian
		pembelian = record
			noAkun : string;
			jenisBrg : string;
			penyedia : string;
			noTujuan : string;
			mataUang : string;
			jumlah : longint;
			saldo : longint;
			tglTransaksi : Tanggal;
		end;
		//Data perbandingan kurs mata uang
		tukarMataUang = record
			nkursAsal : real;
			kursAsal : string;
			nkursTujuan : real;
			kursTujuan : string;
		end;
		//Data list barang yang dapat dibeli oleh user
		listBarang = record
			jenis : string;
			penyedia : string;
			harga : longint;
		end;
	
	{STRUKTUR PENYIMPANAN INTERNAL}
		
		arrRekening =record
			rek : array [1..Nmax] of rekening;
			Neff : integer;
		end;
	
		arrNasabah = record
			data : array [1..15] of nasabah;
			Neff : integer;
		end;
	
		arrTransaksi = record
			trans : array [1..Nmax] of transaksi;
			Neff : integer;
		end;
	
		arrTransfer = record
			transf : array [1..Nmax] of transTransfer;
			Neff : integer;
		end;
	
		arrPembayaran = record
			bayar : array [1..Nmax] of pembayaran;
			Neff : integer;
		end;
	
		arrPembelian = record
			beli : array [1..Nmax] of pembelian;
			Neff : integer;
		end;
	
		arrTukar = record
			tukarUang : array [1..3] of tukarMataUang;
			Neff : integer;
		end;
	
		arrListBarang = record
			list : array [1..11] of listBarang;
			Neff : integer;
		end;
	
	var
		isRekloaded,isDataLoaded,isTransLoaded:boolean;
		isTransfLoaded,isBayarLoaded,isBeliLoaded:boolean;
		isMataUangLoaded,isListBarangLoaded,isLoggedIn:boolean;
		isNasabahKosong,isError:boolean;
		isRekKosong,isTransKosong:boolean;
		isTransfKosong,isBayarKosong,isBeliKosong:boolean;
		isMataUangKosong,isListBarangKosong:boolean;
		user,pass,command,namafile: string;
		Index,kolom : integer;
		i,j,k :integer;
		Str1, Str2, Str3: AnsiString;
		mulai, akhir, pos: int64;
		//Load Rekening Online
		arrRek : arrRekening;
		DataRekening: Text;
		//Load Data Nasabah
		arrData : arrNasabah;
		DataNasabah: Text;
		//Load Data Transaksi
		arrTrans : arrTransaksi;
		DataTransaksi: Text;
		//Load Data Transfer
		arrTransf : arrTransfer;
		DataTransfer: Text;
		//Load Data Pembayaran
		arrBayar : arrPembayaran;
		DataPembayaran: Text;
		//Load Data Pembelian
		arrBeli : arrPembelian;
		DataPembelian: Text;
		//Load Data Penukaran Mata Uang
		arrMatauang : arrTukar;
		DataMataUang: Text;
		//Load Data List Barang
		arrList : arrListBarang;
		DataListBarang: Text;
		isKosong:boolean;
		Year,Month,Day,WDay : word;
	    Hour,Min,Sec,HSec : word;

implementation

	Function L0(w:word):string;
	var
	  s : string;
	begin
	  Str(w,s);
	  if w<10 then
	   L0:='0'+s
	  else
	   L0:=s;
	end;

end.	
	
