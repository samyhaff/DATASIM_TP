# DATASIM_TP

Ajouts utiles shell :

```bash
# création de rapport
rapport () {
    mkdir rapport; mkdir rapport/images
    cd rapport
    cp $HOME/Notes/cours/DATASIM_TP/template.tex ./rapport.tex
}

# ajout du préambule
export TEXINPUTS=".:~/Notes/cours/DATASIM_TP/packages:"
```
