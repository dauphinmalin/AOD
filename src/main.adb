with Ada.Text_IO, Ada.Integer_Text_Io, arbre_optimal, Ada.Streams.Stream_IO, Ada.IO_Exceptions, Ada.Command_line;
use Ada.Text_IO, Ada.Integer_Text_Io, arbre_optimal, Ada.Streams.Stream_IO, Ada.Command_line;

procedure main is

n : Integer:= Integer'Value(Argument(2));
type T_Int is array(0..n,0..n) of Integer;

  procedure Mise_En_Place_Optimal(Nom_Fichier : in String; n : in Integer; R : out T_Int) is --Le but est de construire R tel que R(i,j) donne la racine optimal pour l'arbre T(i,j)
    Fichier : Ada.Streams.Stream_IO.File_Type;
    Flux : Ada.Streams.Stream_IO.Stream_Access;
    S : Float; --sommes de tous les entiers contenus dans le fichier (sommes des proba)
    P : array(0..n) of Float; -- ce tableau sert à faire un premier enregistrement des characters présents dans le fichier
    C : array(0..n,0..n) of Float ; -- C(i,j) = cout de l arbre T(i,j)
    W : array(0..n,0..n) of Float ; -- W(i,j) = somme des p(k) pour k allant de i à j-1
    TEST : array(0..8) of Integer; -- TEST permet de tester sans lecture de fichier
    j : Integer;
    Cmin : Float; -- Cmin
    m : Integer; -- valeur de k minimisant C(i,k-1)+C(k,j)
    I : Integer; -- Valeur de l'entier (valeur sur un noeud)
    test1 : Integer;
  begin
    m := -1;
    S := 0.0;
    I := 0;
    TEST(0) := 3; TEST(1) := 2; TEST(2) := 50; TEST(3) := 5; TEST(4) := 79; TEST(5) := 46; TEST(6) := 348; TEST(7) := 7; TEST(8) := 5;
    Put("N=");Put(n);
    for i in 1..n loop
      for j in 0..n loop
        R(i,j):=-1;
      end loop;
    end loop;
    for j in 0..n loop
      --TEST(j):=j+1;
      P(j):=0.0;
      C(j,j):=0.0;
      W(j,j):=0.0;
      R(j,j):=j;
    end loop;
    --Open(Fichier, In_File, Nom_Fichier);
    --Flux := Stream(Fichier);

    --Put("Lecture des donnees: ");

    --while not End_Of_File(Fichier) or I <= n-1 loop -- on lit le fichier
    while I <= n loop -- on lit le fichier
      --Put(I);
      --test:=Integer'Input(Flux);
      --P(I):=Float'Input(Flux); -- Ajout de la proba dans le tableau
      P(I):=Float(TEST(I));
      test1:=TEST(I);

      S := S + (P(I)); -- MaJ de la somme des proba
      I := I + 1; --indice correspondant à l'entiers
    end loop;
    --Put_Line("TEST2");
    ----Close(Fichier);
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

        --Put("i =");
        --Put(i);
        --Put("j =");
        --Put(j);
        W(i,j):=W(i,j-1)+P(j);
        Cmin := 100.0; --PB ? initialisation
        m:=j;
        for k in (i+1)..j loop
            if(C(i,k-1)+C(k,j) < Cmin) then
              Cmin := C(i,k-1)+C(k,j);
              m := k;
              --Put("m =");
              --Put(m);
            end if;
        end loop;
        C(i,j):=W(i,j)+Cmin;
        R(i,j):= m;
        --Put("I" & Integer'Image(i) & "J" & Integer'Image(j) & "m" & Integer'Image(m));
      end loop;
    end loop;
    Put(Float'Image(S));
  end Mise_En_Place_Optimal;



R : T_Int; --Contient en R(i,j) la racine optimal pour l'arbre T(i,j)
A : Arbre;
begin

  Mise_En_Place_Optimal(Argument(1), n, R);
  Put_Line("R :=");
  --for i in 0..n loop
  --  for j in 0..n loop
  --    if(i<=j) then
  --      New_line(1);
  --      Put(Integer'Image(R(i,j)));
  --      Put(" i " & Integer'Image(i));
  --      Put(" j " & Integer'Image(j));
  --      New_line(1);
  --    end if;
  --  end loop;
  --end loop;
  A := Construit_Abr_Optimal(0,n-1,R);

end main;
