import React from "react"
import styles from "./field.module.scss"

interface FieldProps {
    column: number
    row: number
}

export const Field = ({column, row}: FieldProps) => (
    <div className={styles.field}>
        <div data-index={`${column}-${row}`} className={styles.content}/>
    </div>
)
