import React, {useState} from "react"
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

type TKinds = {
    "satyr": Array<string>
    "golem": Array<string>
    "minotaur": Array<string>
    "wraith": Array<string>
}

const kinds: TKinds = {
    "satyr": [satyr1, satyr2, satyr3],
    "golem": [golem1, golem2, golem3],
    "minotaur": [minotaur1, minotaur2, minotaur3],
    "wraith": [wraith1, wraith2, wraith3]
}

export type TKind = keyof TKinds

interface UnitProps {
    unit: TUnit
}

export type TUnit = {
    kind: TKind
    level: number
    row?: number
    column?: number
    live?: number
    attack?: number
    speed?: number
    label?: string
}

export const Unit = ({unit}: UnitProps) => {
    const [openStatsPreview, setOpenStatsPreview] = useState<boolean>()

    return (
        <section onMouseEnter={() => setOpenStatsPreview(true)}
                 onMouseLeave={() => setOpenStatsPreview(false)}
                 className={`${styles.unit} 
                             ${unit.label === "red" && styles.red} 
                             ${unit.label === "blue" && styles.blue}`}
        >
            <img src={kinds[unit.kind][unit.level - 1]} alt={unit.kind}/>
            <span>{unit.live}</span>
            {unit.label && openStatsPreview && (
                <div className={`${styles.statsPreview}
                                 ${unit.label === "red" && styles.red}
                                 ${unit.label === "blue" && styles.blue}`}>
                    <Stat name="Realm" value={unit.label}/>
                    <Stat name="Kind" value={unit.kind}/>
                    <Stat name="Level" value={unit.level}/>
                    <Stat name="Live" value={unit.live}/>
                    <Stat name="Attack" value={unit.attack}/>
                    <Stat name="Speed" value={unit.speed}/>
                    <Stat name="Position" value={`${unit.column} / ${unit.row}`}/>
                </div>
            )}
        </section>
    )
}

function Stat({name, value}: { name: string, value: any }) {
    return (
        <div className="swell">
            <div>{name}:</div>
            <div>{value}</div>
        </div>
    )
}
