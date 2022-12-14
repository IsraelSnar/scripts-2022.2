#!/bin/python3

from unidecode import unidecode

profs = ['Informática e Organização de Computadores', 'Fundamentos de Programação', 'Teoria Geral da Administração', 'Matemática Computacional', 'Métodos e Técnicas de Pesquisa', 'Redes de Computadores', 'Programação Orientada a Objetos', 'Sistemas Operacionais', 'Empreendedorismo', 'Probabilidade e Estatística', 'Internet e Arquitetura TCP/IP', 'Administração de Sistemas Operacionais Windows', 'Administração de Sistemas Operacionais Linux', 'Fundamentos de Banco de Dados', 'Redes de Alta Velocidade', 'Redes de Comunicação Móveis', 'Laboratório em Infra-estrutura de Redes', 'Programação de Scripts', 'Sistemas Distribuídos', 'Ética, Direito e Legislação', 'Gerência de Redes', 'Tópicos Avançados em Redes de Computadores', 'Segurança da Informação', 'Serviços de Redes', 'Projeto de Pesquisa Científica e Tecnológica', 'Projeto Integrado em Redes de Computadores', 'Gestão de Tecnologia da Informação e Comunicação', 'Análise de Desempenho de Redes', 'Desenvolvimento de Software para WEB', 'Gerência de Projetos']

nov_prof = []

for i in profs:
    i = i.replace(" ", "_")
    i = i.replace("/", "_")
    i = i.replace(",", "_")
    i = i.replace("__", "_")
    
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
