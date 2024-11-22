class Emocion { 
    var property eventosRegistrados = [] 
    var property valorIntencidadElevada 
    var property causa  

    method actualizarIntencidadElevada(valor) {    
        valorIntencidadElevada = valor
    }

    method puedeLiberarse()
    
    method liberar(evento) {    
        eventosRegistrados.add(evento)

        if (self.puedeLiberarse()) {    
            self.procesoLiberacion(evento)
        }
    }

    method procesoLiberacion(evento)

    method circunstancias() 

    method intencidadElevada(intencidad) = intencidad >= valorIntencidadElevada
}

class Furia inherits Emocion {  
    var property palabrotas = []
    var property intencidad = 100

    override method puedeLiberarse() = self.intencidadElevada(intencidad) && self.tienePalabrota() 

    override method procesoLiberacion(evento) {  
        const ultimaPalabrota = palabrotas.last()
        
        self.intencidad(evento.impacto()) 
        palabrotas.remove(ultimaPalabrota)
        eventosRegistrados.add(evento)
    } 

    method tienePalabrota() = palabrotas.any{ palabrota => palabrota.size() > 7 }
}

class Alegria inherits Emocion {
    var property intencidad = self.circunstancias()
    
    override method puedeLiberarse() = self.intencidadElevada(intencidad) && (self.eventosRegistrados().size() % 2) === 0 

    override method procesoLiberacion(evento) { 
        if (self.intencidad() - evento.impacto() < 0) {  
            intencidad = evento.impacto()
        } else {    
            intencidad -= evento.impacto()
        }
    }


    override method circunstancias() = 100 // aca decidi definir este metodo para asignarle un valor a la intencidad de la emocion para que sea flexible a la 

}

class Tristeza inherits Emocion {  
    var property intencidad // como dice que su intencidad puede variar sin limitaciones, dejo este atributo configurable a la hora de instanciar la emocion 
    override method puedeLiberarse() = self.intencidadElevada(intencidad) && (self.causa() != "melancolía")
    
    override method procesoLiberacion(evento) {
        self.causa(evento.descripcion())
        intencidad -= evento.impacto()
    }
    
}

class Desagrado inherits Emocion {   
    var property intencidad 

    override method puedeLiberarse() = self.intencidadElevada(intencidad) && self.eventosRegistrados().size() > self.intencidad() 

    override method procesoLiberacion(evento) {   
        intencidad -= evento.impacto()
    }
}

class Temor inherits Desagrado {    
    // Decidi instanciarla de la clase desagrado ya que comparten la misma logica, asi no repetia codigo y puedo tratarlas como dos emociones diferentes
}

class Evento {
    const property descripcion  

    method impacto() = 0.randomUpTo(100)

    method liberarEmociones(emociones) {    
        emociones.filter{ emocion => emocion.puedeLiberarse() }.forEach{ emocion => emocion.liberar(self) }
    } 
}

class AprobarParcial inherits Evento {  

    override method liberarEmociones(emociones) {    
        emociones.filter{ emocion => emocion.intencidad() > 100 }.forEach{ emocion => emocion.liberar(self) }
        
    }
}

class Persona { 
    var property edad  
    var property emociones = []

    method circunstancias() {   

    }

    method esAdolescente() = edad >= 12 && edad < 19

    method nuevaEmocion(emocion) {  
        emociones.add(emocion)
    }

    method estaPorExplotar() = emociones.all{ emocion => emocion.puedeLiberarse() }

    method vivirEvento(evento) {    
        evento.liberarEmociones(emociones.filter{ emocion => emocion.puedeLiberarse() })
    }
}

class GrupoPersonas {   
    var property personas = #{}

    method vivirEvento(evento) {    
        personas.forEach{ persona => persona.vivirEvento(evento) }
    } 
}

class Ansiedad inherits Emocion {   
    var property intencidad = self.eventosRegistrados() 

    method nivelAnsiedad() = self.intencidad() * 2

    override method puedeLiberarse() = self.intencidadElevada(intencidad) && self.nivelAnsiedad() > 40

    override method procesoLiberacion(evento) { 
        intencidad -= self.nivelAnsiedad() * 1.5
    }
}
// para inventar esta nueva clase, los conceptos de polimorfismo y herencia me fueron utiles para evitar la repeticion de codigo y lograr una mayor flexibilidad a la hora de definir los metodos especificos para esta clase, ya que con el mismo mensaje que entienden todas las emociones puedo hacer una implementacion distinta en esta clase


const aprobarParcial = new AprobarParcial(descripcion="parcial paradigma orientado a objetos")

const persona1 = new Persona(edad = 19)
const persona2 = new Persona(edad = 20)

const alegria = new Alegria(valorIntencidadElevada=100, causa= "")

const grupo = new GrupoPersonas(personas=#{persona1, persona2})

