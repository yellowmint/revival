import React from "react"

interface StatusProps {
    status: string
    round: number
}

export const Status = ({status, round}: StatusProps) => (
    <section className="swell">
        <div>
            Status: {status.replace("_", " ")}
        </div>
        <div>
            {round !== null && <>Round: {round}</>}
        </div>
    </section>
)
