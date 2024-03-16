import { ChangeEventHandler } from "react";
import { Button } from "./button";
import { CoinSelect } from "./coinSelect";
import { FunkyFontWrapper } from "./funkyFontWrapper";
import { Input } from "./input";
import { Tooltip, TooltipContent, TooltipTrigger } from "./tooltip";
import { Action, Coin } from "../../commonTypes";
import { cn } from "../../lib/utils";

export const CardContent = ({
  amount,
  onAmountChange,
  coin,
  onCoinChange,
  onSubmit,
  infoRows,
  action,
}: {
  amount: string;
  onAmountChange: (val: string) => void;
  coin: Coin;
  onCoinChange: (val: Coin) => void;
  onSubmit: () => void;
  infoRows: { title: string; value: string }[];
  action: Action;
}) => {
  const amountChangeHandler: ChangeEventHandler<HTMLInputElement> = ({
    target: { value },
  }) => {
    if (!value || /^\d+(\.\d*)?$/.test(value)) {
      onAmountChange(value);
    }
  };
  const isValidAmount = !!amount;
  return (
    <>
      <FunkyFontWrapper className="text-2xl py-4">
        You {action === "Supply" ? "supply" : "borrow"}
      </FunkyFontWrapper>
      <div className="flex flex-row gap-3 mb-4">
        <CoinSelect onChange={onCoinChange} value={coin} />
        <Input
          placeholder="E.g.: 0.1"
          value={amount}
          onChange={amountChangeHandler}
        />
      </div>
      <Tooltip delayDuration={200} disableHoverableContent>
        <TooltipTrigger asChild>
          <Button
            size="lg"
            className="w-full"
            onClick={onSubmit}
            disabled={!isValidAmount}
          >
            {action === "Supply" ? "Supply" : "Borrow"} {coin}
          </Button>
        </TooltipTrigger>
        {!isValidAmount && (
          <TooltipContent side="bottom">Please, provide amount</TooltipContent>
        )}
      </Tooltip>
      <div className="mt-4">
        {infoRows.map((r, i) => (
          <div
            key={r.title}
            className={cn(
              "flex rounded-lg px-2 py-[2px] h-8 items-center justify-between opacity-60",
              i % 2 === 0 && "bg-opacity-5 bg-black",
            )}
          >
            <span>{r.title}</span>
            <span>{r.value}</span>
          </div>
        ))}
      </div>
    </>
  );
};
