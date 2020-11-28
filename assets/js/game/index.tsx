import React, { useEffect, useState } from "react"
import { Socket } from "phoenix"


export const Game: React.FC = () => {
    useEffect(() => {
        const socket = new Socket('/socket', { params: { token: "your auth token" } })
        socket.connect()

        const pathname = window.location.pathname
        const id = pathname.substring(pathname.lastIndexOf('/') + 1)

        const channel = socket.channel("game:" + id)
        channel.join()
            .receive("ok", resp => { console.log("Joined successfully", resp) })
            .receive("error", resp => { console.log("Unable to join", resp) })
    }, [])

    return (
        <section className="phx-hero">
            Siema
        </section>
    )
}

