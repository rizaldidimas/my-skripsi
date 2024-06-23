numCities = 9;
numAnts = 10;
numIterations = 100;
alpha = 1;  % pengaruh pheromone
beta = 2;   % pengaruh jarak
evaporationRate = 0.5;
pheromoneInit = 1 / (numCities * mean(mean(d))); % Inisialisasi pheromone

pheromone = pheromoneInit * ones(numCities, numCities);

function probs = computeProbabilities(pheromone, d, alpha, beta, visited)
    tau_eta = (pheromone.^alpha) .* ((1.0 ./ d).^beta);
    tau_eta(visited) = 1; % Hapus kota yang sudah dikunjungi dari probabilitas
    total = sum(tau_eta);
    probs = tau_eta / total;
end

bestRoute = [];
bestRouteLength = inf;

for iter = 1:numIterations
    routes = zeros(numAnts, numCities);
    routeLengths = zeros(numAnts, 1);

    for k = 1:numAnts
        visited = zeros(1, numCities);
        startCity = randi(numCities);
        currentCity = startCity;
        route = currentCity;
        visited(currentCity) = 1;

        for step = 2:numCities
            probs = computeProbabilities(pheromone, d, alpha, beta, visited);
            nextCity = rouletteWheelSelection(probs);
            route = [route, nextCity];
            visited(nextCity) = 1;
            currentCity = nextCity;
        end

        route = [route, startCity]; % kembali ke kota awal
        routes(k, :) = route;
        routeLengths(k) = calculateRouteLength(route, d);

        if routeLengths(k) < bestRouteLength
            bestRoute = route;
            bestRouteLength = routeLengths(k);
        end
    end

    % Update pheromone
    pheromone = (1 - evaporationRate) * pheromone;

    for k = 1:numAnts
        for step = 1:(numCities-1)
            i = routes(k, step);
            j = routes(k, step+1);
            pheromone(i, j) = pheromone(i, j) + 1 / routeLengths(k);
            pheromone(j, i) = pheromone(i, j); % simetris
        end
    end
end

function nextCity = rouletteWheelSelection(probs)
    cumulativeSum = cumsum(probs);
    r = rand();
    nextCity = find(cumulativeSum >= r, 1);
end

function length = calculateRouteLength(route, d)
    length = 0;
    for i = 1:(length(route)-1)
        length = length + d(route(i), route(i+1));
    end
end
