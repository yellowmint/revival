import React from "react"
import styles from "./field.module.scss"

interface FieldProps {
    column: number
    row: number
    isRevival: boolean
    onClick: (() => void) | undefined
}

export const Field = ({column, row, isRevival, onClick}: FieldProps) => (
    <div className={styles.field} onClick={onClick}>
        <div data-index={`${column}-${row}`}
             className={`${styles.content} ${isRevival && styles.revivalSpot}`}
        />
    </div>
)
