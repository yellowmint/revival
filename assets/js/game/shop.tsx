import React, {useState} from "react"
import styles from "./shop.module.scss"
import {TKind, Unit} from "./unit"

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
    price: number
}

export const Shop = ({shop}: ShopProps) => {
    const [selected, setSelected] = useState<TGood>()

    return (<section className={styles.shop}>
            <div className={styles.wrapper}>
                {shop.goods.map(good => (
                    <div key={`${good.kind}-${good.level}`} onClick={() => setSelected(good)}>
                        <ShopUnit good={good} selected={selected === good}/>
                    </div>
                ))}
            </div>
        </section>
    )
}

interface TShopUnitProps {
    good: TGood
    selected: boolean
}

export const ShopUnit = ({good, selected}: TShopUnitProps) => (
    <div className={`${styles.shopUnit} ${selected && styles.selected}`}>
        <Unit kind={good.kind} level={good.level}/>
        <div className="swell-around">
            <span className={styles.countBadge}>{good.count}</span>
            <span className={styles.moneyBadge}>{good.price}</span>
        </div>
    </div>
)
