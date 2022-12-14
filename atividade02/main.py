#!/bin/python3

from unidecode import unidecode

profs = ['Alisson Barbosa de Souza', 'André Ribeiro Braga', 'Andréia Libório Sampaio', 'Antonia Diana Braga Nogueira', 'Antônio Joel Ramiro de Castro', 'Antonio Rafael Braga', 'Arthur de Castro Callado', 'Arthur Rodrigues Araruna', 'Atílio Gomes Luiz', 'Bruno Góis Mateus', 'Camilo Camilo Almendra', 'Carla Ilane Moreira Bezerra', 'Carlos Igor Ramos Bandeira', 'Carlos Roberto Rodrigues Filho', 'Cristiano Bacelar de Oliveira', 'Criston Pereira de Souza', 'Davi Romero de Vasconcelos', 'David Sena Oliveira', 'Diana Patrícia Medina Pereira', 'Elvis Miguel Galeas Stancanelli', 'Emanuel Ferreira Coutinho', 'Enyo José Tavares Gonçalves', 'Fábio Carlos Sousa Dias', 'Francisco Erivelton Fernandes de Aragão', 'Francisco Helder Candido dos Santos Filho', 'Germana Ferreira Rolim', 'Ingrid Teixeira Monteiro', 'Jeandro de Mesquita Bezerra', 'Jeferson Kenedy Morais Vieira', 'Jefferson de Carvalho Silva', 'Jefferson de Carvalho Silva', 'João Marcelo Uchôa de Alencar', 'João Vilnei de Oliveira Filho', 'José Neto de Faria', 'Lívia Almada Cruz', 'Lucas Ismaily Bezerra Freitas', 'Luis Rodolfo Rebouças Coutinho', 'Marcio Espíndola Freire Maia', 'Marcos Antonio de Oliveira', 'Marcos Dantas Ortiz', 'Maria Viviane de Menezes', 'Michel Sales Bonfim', 'Paulo Armando Cavalcante Aguilar', 'Paulo de Tarso Guerra Oliveira', 'Paulo Henrique Macedo de Araujo', 'Paulo Victor Barbosa de Sousa', 'Paulyne Matthews Jucá', 'Rainara Maia Carvalho', 'Regis Pires Magalhães', 'Ricardo Reis Pereira', 'Roberto Cabral Rabêlo Filho', 'Rochelle Silveira Lima','Rubens Fernandes Nunes','Samy Soares Passos de Sá','Tânia Saraiva de Melo Pinheiro','Thiago Werlley Bandeira da Silva', 'Valdemir Pereira de Queiroz Neto', 'Victor Aguiar Evangelista de Farias', 'Wagner Guimarães Al-Alam', 'Wladimir Araujo Tavares']

nov_prof = []

for i in profs:
    i = i.replace(" ", "_")
    i = i.lower()
    nov_prof.append(unidecode(i))
    
for i in nov_prof:
    try:
        #nome_arquivo = input('Nome do arquivo a ser editado:')
        arquivo = open(i, 'r+')

    except FileNotFoundError:
        arquivo = open(i+'.txt', 'w+')
        #arquivo.writelines(u'Arquivo criado pois nao existia')
        #faca o que quiser
    arquivo.close()
