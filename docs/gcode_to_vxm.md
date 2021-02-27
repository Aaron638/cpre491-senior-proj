```cs
    // If X does not move, the Velmex command only updates Y (motor 3)
    else if (Math.Round(deltaX) == 0)
    {
        retStr = String.Format("F,PM-1,S3M{0},I3M{1},R", Math.Round(speedY, 0), Math.Round(deltaY, 0));
    }
    // If Y does not move, the Velmex command only updates X (motor 2)
    else if (Math.Round(deltaY) ==0)
    {
        retStr = String.Format("F,PM-1,S2M{0},I2M{1},R", Math.Round(speedX, 0), Math.Round(deltaX, 0));
    }
    // Otherwise, the Velmex command moves both motor 2 and motor 3
    else
    {
        retStr = String.Format("F,PM-1,S2M{0},S3M{1},(I3M{2},I2M{3},)R", Math.Round(speedX, 0), Math.Round(speedY, 0), Math.Round(deltaY, 0), Math.Round(deltaX, 0));
    }
```
