with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with dico; use dico;
with Code; use Code;
-- paquetage representant un ABR optimal de caracteres

package Arbre_Optimal is

	type Arbre is private;

	type Arbre_Optimal is record
		-- l'arbre optimal proprement dit
		A : Arbre;
		-- autres infos utiles: nb total de caracteres lus, ...
		Nb_Total_Caracteres : Natural;
		-- A completer selon vos besoins!
	end record;

	-- Libere l'arbre de racine A.
	-- garantit: en sortie toute la memoire a ete libere, et A = null.
	function creer_arbre(C: Character;i:Integer) return Arbre;
	procedure Libere_Arbre(A: in out Arbre);
	procedure Libere(H : in out Arbre_Optimal);
	procedure Affiche_Arbre(A:in Arbre);
	procedure Affiche(H : in Arbre_Optimal);


	-- Cree un arbre optimal a partir d'un fichier texte
	-- Cette function lit le fichier et compte le nb d'occurences des
	-- differents caracteres presents, puis genere l'arbre correspondant
	-- et le retourne.
procedure Fusion_Arbre(moins_prio1: in out Arbre_Optimal;moins_prio2: in Arbre_Optimal) ;

	function Cree_Optimal(Nom_Fichier : in String)
		return Arbre_Optimal;

	-- Stocke un arbre dans un flux ouvert en ecriture
	-- Le format de stockage est celui decrit dans le sujet
	-- Retourne le nb d'octets ecrits dans le flux (pour les stats)
	procedure Ecrit_Arbre(A:in Arbre;Flux : Ada.Streams.Stream_IO.Stream_Access);
	function Ecrit_Optimal(H : in Arbre_Optimal;
	                        Flux : Ada.Streams.Stream_IO.Stream_Access)
		return Positive;

	-- Lit un arbre stocke dans un flux ouvert en lecture
	-- Le format de stockage est celui decrit dans le sujet
	function Lit_Optimal(Flux : Ada.Streams.Stream_IO.Stream_Access)
		return Arbre_Optimal;


	-- Retourne un dictionnaire contenant les caracteres presents
	-- dans l'arbre et leur code binaire (evite les parcours multiples)
	-- de l'arbre

	procedure Genere_Dic_Arbre(A: in Arbre; D:in out Dico_Caracteres;C: in out Code_Binaire) ;
	function Genere_Dictionnaire(H :  Arbre_Optimal) return Dico_Caracteres;



------ Parcours de l'arbre (decodage)

-- Parcours a l'aide d'un iterateur sur un code, en partant du noeud A
--  * Si un caractere a ete trouve il est retourne dans Caractere et
--    Caractere_Trouve vaut True. Le code n'a eventuellement pas ete
--    totalement parcouru. A est une feuille.
--  * Si l'iteration est terminee (plus de bits a parcourir ds le code)
--    mais que le parcours s'est arrete avant une feuille, alors
--    Caractere_Trouve vaut False, Caractere est indetermine
--    et A est le dernier noeud atteint.
--	procedure Get_Caractere(It_Code : in Iterateur_Code; A : in out Arbre;
	--			Caractere_Trouve : out Boolean;
		--		Caractere : out Character);


private

	-- type Noeud prive: a definir dans le body du package, AbrOptimal.adb
	type Noeud;

	type Arbre is Access Noeud;

end Arbre_Optimal;
