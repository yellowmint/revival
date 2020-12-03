import React from "react"
import styles from "./shop.module.scss"
import {ShopUnit, TKind} from "./unit"

interface ShopProps {
    shop: TShop
}

export type TShop = {
    goods: Array<TGood>
}

type TGood = {
    kind: TKind
    level: number
    count: number
}

export const Shop = ({shop}: ShopProps) => (
    <section className={styles.shop}>
        <div className={styles.wrapper}>
            {shop.goods.map(good => (
                <div key={`${good.kind}-${good.level}`}>
                    <ShopUnit kind={good.kind} level={good.level} count={good.count}/>
                </div>
            ))}
        </div>
    </section>
)
