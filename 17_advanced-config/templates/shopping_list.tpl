Shopping list - ${date}
%{ for item, quantity in list }
${item}: ${quantity}
%{ endfor ~}
