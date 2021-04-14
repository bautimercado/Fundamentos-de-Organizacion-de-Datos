program nueve;

const
	corte = 32767;
	
type
	tMesaElectoral = record
		codProvincia : integer;
		codLocalidad : integer;
		numeroDeMesa : integer;
		cantVotos : integer;
	end;

	archivoVotos = file of tMesaElectoral;
	
procedure leerArchivo (var arc : archivoVotos; var reg : tMesaElectoral);
begin
	if (not eof(arc)) then
		read(arc, reg)
	else
		reg.codProvincia := corte;
end;
	
var
	votos : archivoVotos;
	regM : tMesaElectoral;
	provActual, locActual, votosProv, votosLoc, total : integer;
begin
	assign(votos, 'votos');
	reset(votos);
	
	votosProv := 0;
	votosLoc := 0;
	total := 0;
	
	leerArchivo(votos,regM);
	
	while (regM.codProvincia <> corte) do begin
		provActual := regM.codProvincia;
		locActual := regM.codLocalidad;
		
		writeln('Codigo de provincia: ',provActual);
		writeln('Codigo de localidad     Total de votos ');
		
		while ((regM.codProvincia <> corte) and (locActual = regM.codLocalidad)) do begin
			votosLoc := votosLoc + regM.cantVotos;
			leerArchivo(votos, regM);
		end;
		
		writeln(locActual,'     ',votosLoc);
		votosProv := votosProv + votosLoc;
		votosLoc := 0;
		
		if (provActual <> regM.codProvincia) then begin
			writeln('Total de votos de la provincia: ',votosProv);
			total := total + votosProv;
			votosProv := 0;
		end;
	end;
	writeln('Total general de votos: ',total);
	
	close(votos);
end.