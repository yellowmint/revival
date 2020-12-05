import React from "react"
import styles from "./unit.module.scss"
import golem1 from "./units/golem_1.png"
import golem2 from "./units/golem_2.png"
import golem3 from "./units/golem_3.png"
import minotaur1 from "./units/minotaur_1.png"
import minotaur2 from "./units/minotaur_2.png"
import minotaur3 from "./units/minotaur_3.png"
import satyr1 from "./units/satyr_1.png"
import satyr2 from "./units/satyr_2.png"
import satyr3 from "./units/satyr_3.png"
import wraith1 from "./units/wraith_1.png"
import wraith2 from "./units/wraith_2.png"
import wraith3 from "./units/wraith_3.png"

const kinds = {
    "golem": [golem1, golem2, golem3],
    "minotaur": [minotaur1, minotaur2, minotaur3],
    "satyr": [satyr1, satyr2, satyr3],
    "wraith": [wraith1, wraith2, wraith3]
}

export type TKind = "golem" | "minotaur" | "satyr" | "wraith"

interface UnitProps {
    unit: TUnit
}

export type TUnit = {
    kind: TKind
    level: number
    live?: number
    row?: number
    column?: number
}

export const Unit = ({unit}: UnitProps) => (
    <section className={styles.unit}>
        <img src={kinds[unit.kind][unit.level-1]} alt={unit.kind}/>
    </section>
)
