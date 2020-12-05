import React, {ReactNode} from "react"
import styles from "./field.module.scss"

interface FieldProps {
    isRevivalSpot: boolean
    availableToPlace: boolean
    onClick: (() => void) | undefined
    children: ReactNode
}

export const Field = ({isRevivalSpot, availableToPlace, onClick, children}: FieldProps) => (
    <div className={styles.field} onClick={onClick}>
        <div className={`${styles.content} 
                         ${isRevivalSpot && styles.revivalSpot} 
                         ${availableToPlace && styles.availableToPlace}`}
        >
            {children}
        </div>
    </div>
)
