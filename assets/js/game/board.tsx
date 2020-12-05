import React, {CSSProperties, ReactNode, useContext} from "react"
import styles from "./board.module.scss"
import {Field} from "./field"
import {MoveContext} from "./moveContext"
import {TUnit, Unit} from "./unit"

interface BoardProps {
    board: TBoard
    reversed: boolean
    myMove: boolean
}

export type TBoard = {
    rows: number
    columns: number
    units: Array<TUnit>
    revival_spots: Array<TRevivalSpot>
}

type TRevivalSpot = {
    column: number
    row: number
    label: string
}

export const Board = ({board, reversed, myMove}: BoardProps) => {
    const [ctx, dispatch] = useContext(MoveContext)

    const isRevivalSpot = (columnIdx: number, rowIdx: number): boolean => {
        columnIdx = getColumn(board.columns, reversed, columnIdx)
        rowIdx = getRow(board.rows, reversed, rowIdx)

        return !!board.revival_spots.find(({column, row}) => column === columnIdx && row === rowIdx)
    }

    const availableToPlace = (columnIdx: number, rowIdx: number): boolean => {
        if (!myMove) return false
        if (rowIdx !== board.rows) return false

        columnIdx = getColumn(board.columns, reversed, columnIdx)
        rowIdx = getRow(board.rows, reversed, rowIdx)

        const alreadyPlaced = ctx.moves.find(move => {
            if (move.type !== "place_unit") return false
            return move.position.column === columnIdx && move.position.row === rowIdx
        })

        return !alreadyPlaced
    }

    const getUnit = (columnIdx: number, rowIdx: number): ReactNode => {
        columnIdx = getColumn(board.columns, reversed, columnIdx)
        rowIdx = getRow(board.rows, reversed, rowIdx)

        const unit = board.units.find(unit => unit.column === columnIdx && unit.row === rowIdx)
        if (unit) return <Unit unit={unit}/>

        const move = ctx.moves.find(move => {
            if (move.type !== "place_unit") return false
            return move.position.column === columnIdx && move.position.row === rowIdx
        })
        if (move) return <Unit unit={{kind: move.unit.kind, level: move.unit.level}}/>

        return <></>
    }

    const placeUnit = (columnIdx: number, rowIdx: number) => {
        if (!myMove) return

        columnIdx = getColumn(board.columns, reversed, columnIdx)
        rowIdx = getRow(board.rows, reversed, rowIdx)
        dispatch({type: "placeUnit", payload: {column: columnIdx, row: rowIdx}})
    }

    return (
        <article className={styles.board}>
            <section className={styles.wrapper}
                     style={{"--rows": board.rows, "--columns": board.columns} as CSSProperties}
            >
                {[...Array(board.rows)].map((_, i) => ++i).map(rowIdx =>
                    [...Array(board.columns)].map((_, i) => ++i).map(columnIdx =>
                        <Field key={`${columnIdx}-${rowIdx}`}
                               onClick={rowIdx === board.rows ? () => placeUnit(columnIdx, rowIdx) : undefined}
                               isRevivalSpot={isRevivalSpot(columnIdx, rowIdx)}
                               availableToPlace={availableToPlace(columnIdx, rowIdx)}
                        >
                            {getUnit(columnIdx, rowIdx)}
                        </Field>
                    )
                )}
            </section>
        </article>
    )
}

function getColumn(columns: number, reversed: boolean, column: number) {
    return reversed ? columns - column + 1 : column
}

function getRow(rows: number, reversed: boolean, row: number) {
    return reversed ? rows - row + 1 : row
}
