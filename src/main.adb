with Ada.Text_IO, Ada.Integer_Text_Io, arbre_optimal, Ada.Streams.Stream_IO, Ada.IO_Exceptions, Ada.Command_line;
use Ada.Text_IO, Ada.Integer_Text_Io, arbre_optimal, Ada.Streams.Stream_IO, Ada.Command_line;

procedure main is


n : Integer:= Integer'Value(Argument(1));


procedure Open_Fichier(Fichier :out Ada.Streams.Stream_IO.File_Type; Flux: out Stream_Access; Nom_Fichier: in String ) is
  begin
      Open(Fichier,In_File,Nom_Fichier);
      Flux := Stream(Fichier);
  end Open_fichier;

  procedure Mise_En_Place_Optimal(Nom_Fichier : in String; n : in Integer; R : out T_Int; Cout : out float) is --Le but est de construire R tel que R(i,j) donne la racine optimal pour l'arbre T(i,j)
    Fichier : Ada.Streams.Stream_IO.File_Type;
    Flux : Stream_Access;
    data_read : Character;
    data_value : Integer:=0;
    add : Boolean;
    data_sum : Integer:=0;
    S : Float; --sommes de tous les entiers contenus dans le fichier (sommes des proba)
    P : array(0..n) of Float; -- ce tableau sert à faire un premier enregistrement des characters présents dans le fichier
    C : array(0..n,0..n) of Float ; -- C(i,j) = cout de l arbre T(i,j)
    W : array(0..n,0..n) of Float ; -- W(i,j) = somme des p(k) pour k allant de i à j-1
    j : Integer;
    Cmin : Float; -- Cmin
    m : Integer; -- valeur de k minimisant C(i,k-1)+C(k,j)
    I : Integer; -- Valeur de l'entier (valeur sur un noeud)

  begin
    m := -1;
    S := 0.0;
    I := 0;
    Put("N=");Put(n);
    for i in 1..n loop
      for j in 0..n loop
        R(i,j):=-1;
      end loop;
    end loop;
    for j in 0..n loop

      P(j):=0.0;
      C(j,j):=0.0;
      W(j,j):=0.0;
      R(j,j):=j;
    end loop;
    Open_Fichier(Fichier,Flux,Nom_Fichier);
    Flux := Stream(Fichier);


    --Put("Lecture des donnees: ");

    --while not End_Of_File(Fichier) or I <= n-1 loop -- on lit le fichier
    while I <= n-1 and not End_Of_File(Fichier) loop
      Character'Read(Flux,data_read);
      add:=True;
      if(data_read='0') then
      data_value:=0;
      elsif(data_read='1') then
      data_value:=1;
      elsif(data_read='2') then
      data_value:=2;
      elsif(data_read='3') then
      data_value:=3;
      elsif(data_read='4') then
      data_value:=4;
      elsif(data_read='5') then
      data_value:=5;
      elsif(data_read='6') then
      data_value:=6;
      elsif(data_read='7') then
      data_value:=7;
      elsif(data_read='8') then
      data_value:=8;
      elsif(data_read='9') then
      data_value:=9;
    else if data_sum/=0 then
        Put_Line("valeur ajoutée :" & Integer'Image(data_sum));
        P(I):=Float(data_sum);
        S := S + (P(I));
        I := I + 1;
        data_sum:=0;
      end if;
      add:=False;
    end if;
    if add=True then data_sum:=data_sum*10+data_value;
    end if;

    end loop;
    if data_sum/=0 then
      Put_Line("valeur ajoutée :" & Integer'Image(data_sum));
      P(I):=Float(data_sum);
      S := S + (P(I));
      I := I + 1;
    end if;

    --Put_Line("TEST2");
    Close(Fichier);
    --Put_Line("fermeture du fichier");

    for l in 0..n loop
      P(l):=P(l)/S;
      Put("PROBA");
      Put(Float'Image(P(l)));
    end loop;
    Put_Line("");
    for l in 1..n loop
      for i in 0..n-l loop
        j:= i+l;

        W(i,j):=W(i,j-1)+P(j);
        Cmin := 2000000000000.0; --PB ? initialisation
        m:=j;
        for k in (i+1)..j loop
            if(C(i,k-1)+C(k,j) < Cmin) then
              Cmin := C(i,k-1)+C(k,j);
              m := k;
            end if;
        end loop;
        C(i,j):=W(i,j)+Cmin;
        R(i,j):= m;
      end loop;
    end loop;
    Put(Float'Image(S));
    Cout := C(0,4);
  end Mise_En_Place_Optimal;

R : T_Int(0..n,0..n); --Contient en R(i,j) la racine optimal pour l'arbre T(i,j)
A : Arbre;
Cout : Float;
begin

  Mise_En_Place_Optimal(Argument(2), n, R, Cout);
  Put_Line("Cout" & Float'Image(Cout));
  A := Construit_Abr_Optimal(0,n,R);
  Affiche_Arbre(A);

end main;
